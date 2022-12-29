unit LocMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, ImgList, Buttons, StdCtrls, ValEdit, GeoFunctions,
  GeoFiles, GeoString, GeoClasses, GeoLocalization,  LangLoader, TabFunctions;

type

  TLocPoint = record
    Name       :String;
    N          :Integer;
    X, Y, Z    :array [1..3] of Double;  /// 1 - ���/�� 2 - �����. 3 - ���+��������
  end;

  TFullLocPoint = record
    Name       :String;
    X, Y, Z    :array [1..3] of Double;
    dX, dY, dZ :array [1..2] of Double;
  end;

  T2DParSet = record
    Name1, Name2 :String;
    N1, N2 :Integer;
    Scale, Beta, A, B, C, D, dZ :Double;
  end;

  TLocalizationFm = class(TForm)
    MainGrid: TStringGrid;
    Panel1: TPanel;
    ImageList1: TImageList;
    Label1: TLabel;
    Edit1: TEdit;
    Panel2: TPanel;
    SaveButton: TSpeedButton;
    RefreshButton: TSpeedButton;
    CloseButton: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Panel3: TPanel;
    ShowPan: TSpeedButton;
    ValueList: TValueListEditor;
    Label5: TLabel;
    Bevel1: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel2: TBevel;
    Label8: TLabel;
    CAll: TRadioButton;
    COnly: TRadioButton;
    Isol: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure MainGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MainGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure MainGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure MainGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure MainGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CheckButtons;
    procedure CloseButtonClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure MainGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure ShowPanClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ErrLim :Double;
    ConstScale: Boolean;
    SameHgt: Boolean;

    ChoosedCS  :Integer;

    ChoosedDatum :Integer;
    ChoosedProj  :Integer;
    ChoosedZone  :Integer;
    isLeft:Boolean;

    PX, PY, PZ, PBeta, PScale : Double;
  end;

var
  LocalizationFm: TLocalizationFm;

  RegionBox   : array of HRGN;
  Check       : array of boolean;
  Quality     : array of Byte;

  BitmapIcon1, BitmapIcon2 : TIcon;

  LastText :String;

  LP  :array of TLocPoint;
  aLP :array of TFullLocPoint;
  ParSets :array of T2DParSet;

  Log :TStringList;

const
   GoodColor     = $00BFFCA3;
   NormColor     = $008CE7FD;
   BadColor      = $00AEAEFF;
   InactiveColor = $00EEEEEE;

implementation

uses LocFm, USaveLocaliz;

{$R *.dfm}

procedure TLocalizationFm.FormCreate(Sender: TObject);
begin
  BitmapIcon1 := TIcon.Create;
  ImageList1.GetIcon (0,BitmapIcon1);
  BitmapIcon2 := TIcon.Create;
  ImageList1.GetIcon (1,BitmapIcon2);

  Log := TStringList.Create;
end;

procedure TLocalizationFm.MainGridMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  MX,MY : Integer;
  Coord : TGridCoord;
begin
  Coord:= MainGrid.MouseCoord(X,Y);

  MX:=Mouse.CursorPos.X - MainGrid.ClientOrigin.X;
  MY:=Mouse.CursorPos.Y - MainGrid.ClientOrigin.Y;

  if PtInRegion(RegionBox[Coord.Y],MX, MY)= True
  then MainGrid.Cursor := crHandPoint
  else MainGrid.Cursor := crDefault;

end;

procedure TLocalizationFm.MainGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 with MainGrid do
  begin
    Canvas.Brush.Style := bsClear;

    If ARow = 0 then
    begin
      Canvas.Font.Color  := ClBlack;
      Canvas.Font.Size   := 8;
      Canvas.Font.Style  := [fsBold];

      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := clBtnFace;

      Canvas.Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);

      DrawText(Canvas.Handle, PChar(Cells[ACol ,ARow]), -1, Rect ,
               DT_CENTER or DT_NOPREFIX or DT_VCENTER or DT_SINGLELINE  );

    end else
    Begin
       Canvas.Font.Color  := ClBlack;
       Canvas.Brush.Style := bsSolid;
       case Quality[ARow-1] of
          1: Canvas.Brush.Color    := GoodColor;
          2: Canvas.Brush.Color    := NormColor;
          3: Canvas.Brush.Color    := BadColor;
          0, 4: Canvas.Brush.Color := InactiveColor;
       end;

      if ACol = 0 then
      begin
        Canvas.Rectangle(Rect.Left-1, Rect.Top-1, Rect.Right+1, Rect.Bottom+1);
        RegionBox[ARow] := CreateRectRgn(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);

        Rect.Left := Rect.Left + (MainGrid.ColWidths[0] - 16) div 2;
        Rect.Top  := Rect.Top  + (DefaultRowHeight - 16) div 2;

        if (Check[ARow]=True)
        then
           Canvas.StretchDraw(Rect,BitmapIcon2)
             else
               Canvas.StretchDraw(Rect,BitmapIcon1)
      end
         else
         Begin
             Canvas.Rectangle(Rect.Left-1, Rect.Top-1, Rect.Right+1, Rect.Bottom+1);
             if ACol = 1 then
                DrawText(Canvas.Handle, PChar(Cells[ACol ,ARow]), -1, Rect ,
                  DT_CENTER or DT_NOPREFIX or DT_VCENTER or DT_SINGLELINE)
             else
                DrawText(Canvas.Handle, PChar(Cells[ACol ,ARow]), -1, Rect ,
                  DT_RIGHT or DT_NOPREFIX or DT_VCENTER or DT_SINGLELINE);
         End;
    End;
  end;
end;

procedure TLocalizationFm.MainGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  If MainGrid.Cursor = crHandPoint then
  begin
      Check[MainGrid.Row] := not Check[MainGrid.Row];
      CheckButtons;
  end;

  MainGrid.Refresh;
end;

procedure TLocalizationFm.FormDestroy(Sender: TObject);
begin
  BitmapIcon1.Free;
  BitmapIcon2.Free;
  if ParamStr(1)='-dev' then
    Log.SaveToFile('Localization.txt');
  Log.Free;
end;

procedure TLocalizationFm.MainGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow = 0)or(ACol = 0)or(ACol > 7) then
     MainGrid.Options := MainGrid.Options - [goEditing]
       else
         MainGrid.Options := MainGrid.Options + [goEditing];

   LastText := MainGrid.Cells[ACol,ARow]
end;

procedure TLocalizationFm.MainGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if MainGrid.Selection.Top <= 0 then
     exit;
  if (MainGrid.Selection.Left = 0) and
     ( (Key = vk_return) or (Key = vk_Space)) then
     begin
       Check[MainGrid.Selection.Top] := not  Check[MainGrid.Selection.Top];
       CheckButtons;
     end;
  MainGrid.Repaint;
end;

procedure TLocalizationFm.FormShow(Sender: TObject);
var I :Integer;
begin
 Call.Caption  := inf[51];
 COnly.Caption := inf[52];

 with MainGrid do
  begin
    ColCount     :=  11;
    FixedCols    :=   0;
    FixedRows    :=   1;
    Cells[8,0]   := 'dX';
    Cells[9,0]   := 'dY';
    Cells[10,0]  := 'dH';
  end;
  Panel3.Width := ShowPan.Width;
  Resize;

  SetLength(RegionBox, MainGrid.RowCount);
  SetLength(Check,     MainGrid.RowCount);
  SetLength(Quality,   MainGrid.RowCount);

  for I:= 0 to Length(Check)-1 do
    Check[I]:= True;

  RefreshButton.Click;

  ValueList.TitleCaptions[0]:= inf[53];
  ValueList.TitleCaptions[1]:= inf[54];

end;

procedure TLocalizationFm.FormResize(Sender: TObject);
var I, S:Integer;
begin
  with MainGrid do
  begin
    ColWidths[0] :=  32;
    S := 32;
    for I:= 1 to ColCount-1 do
    begin
      if I < ColCount-1 then
      begin
        MainGrid.ColWidths[I] :=  Round((MainGrid.Width - 32 - 40)/(ColCount-1)) ;
        S := S + ColWidths[I]
      end
        else
         MainGrid.ColWidths[I] := MainGrid.Width - S-40;
    end;
  end;

  ShowPan.Top := (Panel3.Height - ShowPan.Height) div 2;
end;

procedure TLocalizationFm.CheckButtons;
var I, S:Integer;
begin
  S := 0;
  For I := 1 to Length(Check)-1 do
    if Check[I] then
      inc(S);
  RefreshButton.Enabled := S > 2;
  SaveButton.Enabled    := false;
  For I := 1 To MainGrid.RowCount - 1 Do
     for S := 8 to 10 do
       MainGrid.Cells[S,I] := '';

  For I := 1 To MainGrid.RowCount - 1 Do
    Quality[I-1] := 0;

  RefreshButton.Click;  
end;

procedure TLocalizationFm.CloseButtonClick(Sender: TObject);
begin
 close;
end;

procedure TLocalizationFm.RefreshButtonClick(Sender: TObject);
var CoordType :integer;

  procedure InitialCS;
  begin
     CoordType := CoordinateSystemList[ChoosedCS].ProjectionType;

     ChoosedDatum := CoordinateSystemList[ChoosedCS].DatumN;

     LocalizationFm.Label6.Caption :=
          DatumList[ChoosedDatum].Caption;

     if CoordType >= 2 then
       ChoosedDatum := -1;

     if ChoosedDatum = -1 then
       LocalizationFm.Label7.Caption := CoordinateSystemList[ChoosedCS].Caption
         else
           LocalizationFm.Label7.Caption :=  '';
  end;

  procedure TableToArray(Grid:TStringGrid);
  var I, J :Integer;
  begin
     J := 0;
     For I := 1 to Grid.RowCount-1 do
       if Check[I] then
         Inc(j);

     SetLength(LP, J);
     SetLength(aLP, Grid.RowCount-1);
     J := 0;
     for I := 1 To Grid.RowCount -1 Do
     begin
       aLP[I-1].Name := Grid.Cells[1,I];
       if CoordType = 0 then
       begin
         aLP[I-1].X[3] := StrToLatLon(Grid.Cells[2,I],true);
         aLP[I-1].Y[3] := StrToLatLon(Grid.Cells[3,I],false);
       end
         else
         begin
           aLP[I-1].X[3] := StrToFloat2(Grid.Cells[2,I]);
           aLP[I-1].Y[3] := StrToFloat2(Grid.Cells[3,I]);
         end;
       aLP[I-1].Z[3] := StrToFloat2(Grid.Cells[4,I]);
       aLP[I-1].X[2] := StrToFloat2(Grid.Cells[5,I]);
       aLP[I-1].Y[2] := StrToFloat2(Grid.Cells[6,I]);
       aLP[I-1].Z[2] := StrToFloat2(Grid.Cells[7,I]);

       if not isLeft then
       begin
           aLP[I-1].X[2] := StrToFloat2(Grid.Cells[6,I]);
           aLP[I-1].Y[2] := StrToFloat2(Grid.Cells[5,I]);
       end;

       if Check[I] then
       begin
          LP[J].Name := Grid.Cells[1,I];
          LP[J].N  := I;

          if CoordType = 0 then
          begin
            LP[J].X[3] := StrToLatLon(Grid.Cells[2,I],true);
            LP[J].Y[3] := StrToLatLon(Grid.Cells[3,I],false);
          end
            else
            begin
               LP[J].X[3] := StrToFloat2(Grid.Cells[2,I]);
               LP[J].Y[3] := StrToFloat2(Grid.Cells[3,I]);
            end;

          LP[J].Z[3] := StrToFloat2(Grid.Cells[4,I]);
          LP[J].X[2] := StrToFloat2(Grid.Cells[5,I]);
          LP[J].Y[2] := StrToFloat2(Grid.Cells[6,I]);
          LP[J].Z[2] := StrToFloat2(Grid.Cells[7,I]);

          if not isLeft then
          begin
             LP[J].X[2] := StrToFloat2(Grid.Cells[6,I]);
             LP[J].Y[2] := StrToFloat2(Grid.Cells[5,I]);
          end;

          inc(J)
       end;
     end;
  end;

  procedure ProjectionToArrays;
  var I:Integer;
      Mx, My, mZ, tX, tY, tZ :Double;
  begin

    if ChoosedDatum = -1 then
    begin
       For I := 0 To Length(LP)-1 Do
       begin
         LP[I].X[1] := LP[I].X[3];
         LP[I].Y[1] := LP[I].Y[3];
         LP[I].Z[1] := LP[I].Z[3];
       end;
       For I := 0 To Length(aLP)-1 Do
       begin
          aLP[I].X[1] := aLP[I].X[3];
          aLP[I].Y[1] := aLP[I].Y[3];
          aLP[I].Z[1] := aLP[I].Z[3];
       end;
    end
    else
    BEGIN
      { mX :=0;   mY := 0;   mZ :=0;
       For I := 0 To Length(LP)-1 Do
       begin
         mX := mX + LP[I].X[3] / Length(LP);
         mY := mY + LP[I].Y[3] / Length(LP);
         mZ := mZ + LP[I].Z[3] / Length(LP);
       end;                              }


       //// ������� �������� � ����� ����
       ChoosedZone := -100;
       if DatumList[ChoosedDatum].Projections[0]='Gauss' then
           ChoosedProj := 2
             else
               ChoosedProj := 3;

       For I := 0 To Length(LP)-1 Do
       Begin
        with LP[I] Do
        begin
          case CoordType of
             0: begin
               tx := X[3]; ty := Y[3]; Tz := Z[3];
             end;
             1: ECEFToGeo(ChoosedDatum, X[3], Y[3], Z[3], tx, ty, tz);
          end;

          case ChoosedProj of
            2: begin
              GeoToGaussKruger(ChoosedDatum, tx, ty, X[1], Y[1], ChoosedZone, ChoosedZone = -100);
              Z[1] := tz;
            end;
            3: begin
              GeoToUTM(ChoosedDatum, tx, ty, False,  X[1], Y[1],ChoosedZone, ChoosedZone = -100);
              Z[1] := tz;     
            end;
          end;       /// case
        end;  //// LP

      End;

      LocalizationFm.Label7.Caption := inf[35+ChoosedProj] + inf[39] + IntToStr(ChoosedZone);

      Log.Add('�������� ������������� �� '+ Label6.Caption +' � '+ Label7.Caption);

      For I := 0 To Length(aLP)-1 Do
       Begin
        with aLP[I] Do
        begin
          case CoordType of
             0: begin
               tx := X[3]; ty := Y[3]; Tz := Z[3];
             end;
             1: ECEFToGeo(ChoosedDatum, X[3], Y[3], Z[3], tx, ty, tz);
          end;

          case ChoosedProj of
            2: begin
              GeoToGaussKruger(ChoosedDatum, tx, ty, X[1], Y[1], ChoosedZone, false);
              Z[1] := tz;
            end;
            3: begin
              GeoToUTM(ChoosedDatum, tx, ty, False, X[1], Y[1],ChoosedZone, false);
              Z[1] := tz;
            end;
          end;

          Log.Add(  FloatToStr(X[3])+ Tabchar + FloatToStr(Y[3])+ Tabchar + FloatToStr(Z[3]) + Tabchar +
                    format('%.3f',[X[1]]) + Tabchar  +  format('%.3f',[Y[1]])+ Tabchar +  format('%.3f',[Z[1]]));
        end;
      End;

    END;
  end;

  procedure Prepare(G:TSTringGrid; Ex, Ey, Ez :TEdit);
  var I,J :Integer;
  begin
    SetLength(Quality,  MainGrid.RowCount-1);
    for I := 0 To MainGrid.RowCount -1 Do
      Quality[I] := 0;

     For I := 1 To G.RowCount - 1 Do
     for J := 8 to 10 do
       G.Cells[J,I] := '';


     Ex.Text  := '-';
     Ex.Color := InactiveColor;
     Ey.Text  := '-';
     Ey.Color := InactiveColor;
     Ez.Text  := '-';
     Ez.Color := InactiveColor;
  end;

  procedure Combinate;
  var I, J, k, CombCount :Integer;
  begin
    CombCount := 0;
    for I := 0 to Length(LP)-1 Do
      for J := I+1 to Length(LP)-1 Do
         Inc(CombCount);

    Log.Add('����������: '+IntTostr(CombCount));
    SetLength(ParSets, CombCount);

    k := 0;
    for I := 0 to Length(LP)-1 Do
      for J := I+1 to Length(LP)-1 Do
      begin

        ParSets[k].Name1 := LP[i].Name;
        ParSets[k].Name2 := LP[j].Name;
        ParSets[k].N1 := i;
        ParSets[k].N2 := j;

        with ParSets[k] Do
        Loc2D(LP[I].X[1], LP[I].Y[1], LP[I].X[2], LP[I].Y[2],
              LP[J].X[1], LP[J].Y[1], LP[J].X[2], LP[J].Y[2],
              Scale, Beta, A, B, C, D, ConstScale);

        Log.Add(ParSets[k].Name1 + '-' + ParSets[k].Name2 + #$9 +
                format('%.6f',[ParSets[k].Scale]) + #$9 +
                format('%.3f',[ParSets[k].Beta*180/PI]) + #$9 +
                format('%.6f',[ParSets[k].A]) + #$9 +
                format('%.6f',[ParSets[k].B]) + #$9 +
                format('%.3f',[ParSets[k].C]) + #$9 +
                format('%.3f',[ParSets[k].D]) );

        inc(k);
      end;
  end;

  procedure GetDz;
  var I, N:Integer;
      Dz:Double;
  begin
    Dz := 0;
    N := 0;
    if SameHgt then
      Dz := 0
       else
    For I := 0 to Length(LP)-1 do
      if Check[LP[I].N] then
      begin
        Dz := Dz + (LP[I].Z[2] - LP[I].Z[1]);
        inc(N);
      end;

      if N = 0 then
        Dz := 0
          else
            DZ := Dz / N;

    For I := 0 to Length(ParSets)-1 do
      Parsets[I].dZ := Dz;

  end;

  function GetIsoDz (Isolated: Integer): Double;
  var I:Integer;
      Dz:Double;
  begin
    Dz := 0;   Result := 0;
    if Length(LP) <= 1 then exit;

    if SameHgt then
      Dz := 0
       else
    For I := 0 to Length(LP)-1 do
      if I <> Isolated then
      Dz := Dz + (LP[I].Z[2] - LP[I].Z[1])/(Length(LP)-1);

    Result := Dz;
  end;


  procedure MeanParams(var Betam, Scalem, A, B, C, D, ddZ :Double);
  var I, J, N :Integer;
      X1m, Y1m, X2m, Y2m :Double;
  begin

     X1m := 0;  Y1m := 0;   N := 0;
     X2m := 0;  Y2m := 0;

     for I := 0 to Length(LP)-1 do
     begin
        X1m := X1m + LP[I].X[1];
        X2m := X2m + LP[I].X[2];
        Y1m := Y1m + LP[I].Y[1];
        Y2m := Y2m + LP[I].Y[2];
        inc(N);
     end;
     X1m := X1m/N;   X2m := X2m/N;   Y1m := Y1m/N;   Y2m := Y2m/N;

     ScaleM := 0;    BetaM := 0;   ddZ := 0;  N := 0;
     for I := 0 To Length(ParSets)-1 do
     begin
       ScaleM := ScaleM + ParSets[I].Scale;
       BetaM  := BetaM  + ParSets[I].Beta;
       ddZ    := ddZ    + ParSets[I].dZ;
       Inc(N);
     end;
     ScaleM := ScaleM/N;    BetaM := BetaM/N;      ddZ := ddZ/N;

     A := ScaleM * Cos(BetaM);            B := ScaleM * Sin(BetaM);
     C := X2m - (A*X1m - B*Y1m);          D := Y2m - (A*Y1m + B*X1m);

  end;

  procedure IsoMeanParams(Isolated: Integer; var Betam, Scalem, A, B, C, D :Double);
  var I, J, N :Integer;
      X1m, Y1m, X2m, Y2m :Double;
  begin

     N := 0;

     X1m := 0;  Y1m := 0;
     X2m := 0;  Y2m := 0;
     for I := 0 to Length(LP)-1 do
     if I <> Isolated then
     begin
        X1m := X1m + LP[I].X[1];
        X2m := X2m + LP[I].X[2];
        Y1m := Y1m + LP[I].Y[1];
        Y2m := Y2m + LP[I].Y[2];
        inc(N);
     end;

     if N = 0 then
     Begin
        ScaleM := -1 ; // error
        Exit
     End;

     X1m := X1m/N;   X2m := X2m/N;   Y1m := Y1m/N;   Y2m := Y2m/N;

     N := 0;

     ScaleM := 0;    BetaM := 0;
     for j := 0 To Length(ParSets)-1 do
     if (Parsets[j].N1 <> Isolated) and
        (Parsets[j].N2 <> Isolated) then
     begin
       ScaleM := ScaleM + ParSets[I].Scale;
       BetaM  := BetaM  + ParSets[I].Beta ;
       inc(N);
     end;

     if N = 0 then
     Begin
        ScaleM := -1 ; // error
        Exit
     End;

     ScaleM := ScaleM/N;    BetaM := BetaM/N;

     A := ScaleM * Cos(BetaM);            B := ScaleM * Sin(BetaM);
     C := X2m - (A*X1m - B*Y1m);          D := Y2m - (A*Y1m + B*X1m);

  end;

  procedure CalcMeanError(var dxm, dym, dzm: Double; Betam, Scalem,
              A, B, C, D, ddZ :Double; OnlyOn:Boolean);
  var I, J, N :Integer;
      /// Mean Params
  begin

     /// ����������� �� ��������� ������ �����   �  ����� ���

     dXm := 0;  dYm := 0;   dZm := 0;
     for I := 0 to Length(aLP)-1 do
       with aLP[I] do
       begin
         dX[1] := X[2] - (A*X[1] - B*Y[1] + C);
         dY[1] := Y[2] - (B*X[1] + A*Y[1] + D);
         dZ[1] := Z[2] - (Z[1] + ddZ);
         if (OnlyOn = true) and (Check[I+1]) or
            (OnlyOn = false) then
         Begin
           dXm := dXm + Sqr(dX[1]);
           dYm := dYm + Sqr(dY[1]);
           dZm := dZm + Sqr(dZ[1]);
         End;
       end;

       case OnlyOn of
         true:  N := Length(LP);
         false: N := Length(aLP);
       end;

       dXm := Sqrt(dXm / N);
       dYm := Sqrt(dYm / N);
       dZm := Sqrt(dZm / N);
  end;

  function GetCol(err:Double):TColor;
  begin
   if err < ErrLim*0.9 then
      Result := GoodColor
        else
         if err > ErrLim*1.05 then
            Result := BadColor
              else
                Result := NormColor;
  end;

  procedure ErrorToEdit(dx, dy, dz: Double; Ex, Ey, Ez :TEdit);
  begin
    Ex.Text := format('%.3f',[dx]);
    Ey.Text := format('%.3f',[dy]);
    Ez.Text := format('%.3f',[dz]);

    Ex.Color := GetCol(dX);
    Ey.Color := GetCol(dY);
    Ez.Color := GetCol(dZ);
  end;

  procedure  ErrorsToGrid(G:TSTringGrid);
  var I:Integer;
  begin
    for I := 1 to G.RowCount-1 do
    begin
      G.Cells[8,  I] := format('%.3f',[aLP[I-1].dx[1]]);
      G.Cells[9,  I] := format('%.3f',[aLP[I-1].dy[1]]);
      G.Cells[10, I] := format('%.3f',[aLP[I-1].dz[1]]);
    end;
  end;

  procedure ParamsToList(V:TValueListEditor; Beta, Scale, C, D, ddZ :Double);
  begin
    ValueList.Cells[1,1]:= format('%.6f',[Scale]);
    ValueList.Cells[1,2]:= format('%.6f',[Beta*180/pi]);
    ValueList.Cells[1,3]:= format('%.3f',[C]);
    ValueList.Cells[1,4]:= format('%.3f',[D]);
    ValueList.Cells[1,5]:= format('%.3f',[ddZ]);
  end;

  procedure GetQuality;
  var I:Integer;
  begin
    for I := 0 to Length(aLP)-1 do
    begin
      Quality[I] := 1;

      if (abs(aLp[I].dX[1]) >= errLim*0.9) or
         (abs(aLp[I].dY[1]) >= errLim*0.9) or
         (abs(aLp[I].dZ[1]) >= errLim*0.9) then
             Quality[I] := 2;

      if (abs(aLp[I].dX[1]) >= errLim*1.05) or
         (abs(aLp[I].dY[1]) >= errLim*1.05) or
         (abs(aLp[I].dZ[1]) >= errLim*1.05) then
             Quality[I] := 3;

      if (Conly.Checked) and (Check[I+1] = false) then
          Quality[I] := 4;
    end;
  end;

  procedure IsoPointErrors(SG:TStringGrid);
  var I, J, N :Integer;
      /// Mean Params
      Betam, Scalem, A, B, C, D, ddZ, idX, idY, idZ :Double;
  begin

     // ������������� ������ ������ �����

     for I := 0 To Length(LP)-1 do
     begin
       ddZ := GetIsodZ(I);
       IsoMeanParams(I, Betam, Scalem, A, B, C, D);

       if ScaleM = -1 then
          continue;

       with LP[I] do
       begin
          idX := X[2] - (A*X[1] - B*Y[1] + C);
          idY := Y[2] - (B*X[1] + A*Y[1] + D);
          idZ := Z[2] - (Z[1] + ddZ);
       end;

       SG.Cells[8, LP[I].N] :=  SG.Cells[8, LP[I].N] + ' (' +
                                format('%.3f',[idX]) + ')';
       SG.Cells[9, LP[I].N] :=  SG.Cells[9, LP[I].N] + ' (' +
                                format('%.3f',[idY]) + ')';
       SG.Cells[10,LP[I].N] := SG.Cells[10, LP[I].N] + ' (' +
                                format('%.3f',[idZ]) + ')';

     end;

  end;

  var dx, dy, dz :double;
      Beta, Scale, A, B, C, D, ddZ :Double;

begin
  SaveButton.Enabled := False;
  Prepare(MainGrid,Edit1, Edit2, Edit3);
  MainGrid.Repaint;
  InitialCS;
  MainGrid.Options := MainGrid.Options - [goEditing];
  Log.Add('������� ������ '+TimeToStr(Now));

  TableToArray(MainGrid);
  ProjectionToArrays;

  if Length(LP) < 3 then
    exit;

  Combinate;
  GetdZ;

  if Length(ParSets)=0 then
    exit;

  MeanParams(Beta, Scale, A, B, C, D, ddZ);
  ParamsToList(ValueList, Beta, Scale, C, D, ddZ);
  CalcMeanError(dx, dy, dz, Beta, Scale, A, B, C, D, ddZ, COnly.Checked);
  GetQuality;
  ErrorsToGrid(MainGrid);
  ErrorToEdit(dx, dy, dz, Edit1, Edit2, Edit3);
  if Isol.Checked then
    IsoPointErrors(MainGrid);

  Pbeta := Beta;  PScale := Scale;  PX := C;  PY := D;  PZ := ddZ;

  MainGrid.Repaint;
  SaveButton.Enabled := True;
end;

procedure TLocalizationFm.MainGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 If Value <> LastText then
   CheckButtons;
end;

procedure TLocalizationFm.ShowPanClick(Sender: TObject);
begin
  if Panel3.Width = ShowPan.Width  then
    Panel3.Width := 185
    else
      Panel3.Width := ShowPan.Width;
  Resize;
end;

procedure TLocalizationFm.SaveButtonClick(Sender: TObject);
begin
  SaveLoc.Label7.Caption := Label7.Caption;
  SaveLoc.Label8.Caption := Label6.Caption;
  SaveLoc.PlanKind.Items := LocForm.PlanKind.Items;
  SaveLoc.PlanKind.ItemIndex := LocForm.PlanKind.ItemIndex;
  SaveLoc.ValueList.TitleCaptions := ValueList.TitleCaptions;
  SaveLoc.ValueList.Strings := ValueList.Strings;
  SaveLoc.ShowModal;
  Close;
end;

end.
