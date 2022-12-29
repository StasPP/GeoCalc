unit LocFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Buttons, ComCtrls, GeoFunctions, GeoFiles,
  GeoString, GeoClasses, XPMan, ExtCtrls,  LangLoader, OutputPlus;

type
  TLocForm = class(TForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    MB: TComboBox;
    Sc1: TCheckBox;
    Button1: TButton;
    CheckBox2: TCheckBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SK1: TGroupBox;
    Load1: TSpeedButton;
    Save1: TSpeedButton;
    Clear1: TSpeedButton;
    CSCat: TComboBox;
    CSNum: TComboBox;
    StringGrid1: TStringGrid;
    SK2: TGroupBox;
    Clear2: TSpeedButton;
    Save2: TSpeedButton;
    Load2: TSpeedButton;
    Edit1: TEdit;
    PlanKind: TComboBox;
    StringGrid2: TStringGrid;
    ErrLimit: TEdit;
    Label1: TLabel;
    SH: TCheckBox;
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure CSCatChange(Sender: TObject);
    procedure CSNumChange(Sender: TObject);
    procedure MBChange(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Load2Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Clear2Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Save2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    InitDir :String;
    { Public declarations }
  end;

var
  LocForm: TLocForm;

implementation

uses LoadFm, LocMain, MainForm;

{$R *.dfm}

//////////////////////////////////////////////////////////////////////COMBOBOXEZ

procedure HintComboBox(CB:TComboBox);
begin
  CB.Canvas.Font := CB.Font;
  if CB.Canvas.TextWidth(CB.Items[CB.ItemIndex]) > CB.Width - 25 then
  begin
     CB.Hint := CB.Items[CB.ItemIndex];
     CB.ShowHint := true;
  end
    else
      CB.ShowHint := false;
end;

procedure PrepareComboBox(CB:TComboBox);
var I, Lmax :Integer;
begin
  CB.Canvas.Font := CB.Font;

  HintComboBox(CB);

  Lmax := CB.Width;
  for I := 0 To CB.Items.Count - 1 do
    if CB.Canvas.TextWidth(CB.Items[I]) > Lmax then
       Lmax := CB.Canvas.TextWidth(CB.Items[I]) + 25;

  CB.Perform(CB_SETDROPPEDWIDTH, Lmax, 0);
end;

/////////////////////////////////////////////////////////////////////STRINGGRIDZ

type TGridCracker = class(TStringGrid);

procedure SetCaretPosition(Grid: TStringGrid; col, row, x_pos: Integer);
begin
  Grid.Col := Col;
  Grid.Row := Row;
  with TGridCracker(Grid) do
  InplaceEditor.SelStart := x_pos;
end;

procedure TabStringGrid(StringGrid: TStringGrid);
begin
  with StringGrid do
  if Col < ColCount-1 then
    Col:=Col+1
    else
    begin
      Col:=0;
      if Row >= RowCount-1 then
        RowCount := RowCount +1;
      Row:=Row+1;
    end;

end;

procedure ClearGrid(StringGrid: TStringGrid);
var i, j: Integer;
begin
  with StringGrid do
  begin
    for i:=1 to RowCount-1 do
    for j:=0 to ColCount-1 do
      Cells[j, i]:='';
    StringGrid.RowCount := 2;
  end;
end;

procedure DelStringGrid(StringGrid: TStringGrid);
var i, j :integer;
    needDel :Boolean;
begin
  NeedDel:= true;

  if (StringGrid.RowCount < 3) or (StringGrid.Row < 2) then
   exit;


  if StringGrid.Cells[StringGrid.Col,StringGrid.Row]='' then
  Begin

      if  StringGrid.Col > 0 then
        StringGrid.Col :=  StringGrid.Col-1
        else
          Begin

               for i:= 0 to StringGrid.ColCount-1 do
                 if StringGrid.Cells[i,StringGrid.Row]<>'' then
                   begin
                     NeedDel :=false;
                     Break;
                   end;
                if NeedDel then
                begin
                  for i:= StringGrid.Row to StringGrid.RowCount-1 do
                  for j:= 0 to StringGrid.ColCount-1 do
                     StringGrid.Cells[j,i] :=
                        StringGrid.Cells[j,i+1];

                  if StringGrid.Row <> StringGrid.RowCount-1 then
                    StringGrid.Row := StringGrid.Row -1;
                  StringGrid.RowCount := StringGrid.RowCount-1;

                end
                 else
                   StringGrid.Row := StringGrid.Row -1;

              StringGrid.Col :=  StringGrid.ColCount-1;
          End;

      StringGrid.Cells[StringGrid.Col,StringGrid.Row] :=
                       StringGrid.Cells[StringGrid.Col,StringGrid.Row] + ' ';

      SetCaretPosition(StringGrid,StringGrid.Col,
                       StringGrid.Row,
                       Length(StringGrid.Cells[StringGrid.Col,StringGrid.Row]));
  End;
end;

procedure RenameTabs(StringGrid: TStringGrid; TabNameStyle: byte);
begin
  case TabNameStyle of
    4: begin
      StringGrid.Cells[0,0] := Inf[11];
      StringGrid.Cells[1,0] := Inf[6];
      StringGrid.Cells[2,0] := Inf[9];
      StringGrid.Cells[3,0] := inf[17];
    end;

    3: begin
      StringGrid.Cells[0,0] := Inf[11];
      StringGrid.Cells[2,0] := Inf[10];
      StringGrid.Cells[1,0] := Inf[5];
      StringGrid.Cells[3,0] := Inf[17];
    end;

    2: begin
      StringGrid.Cells[0,0] := Inf[11];
      StringGrid.Cells[1,0] := Inf[5];
      StringGrid.Cells[2,0] := Inf[10];
      StringGrid.Cells[3,0] := Inf[17];
    end;

    1: begin
      StringGrid.Cells[0,0] := Inf[11];
      StringGrid.Cells[1,0] := Inf[2];
      StringGrid.Cells[2,0] := Inf[3];
      StringGrid.Cells[3,0] := Inf[4];
    end;

    0: begin
      StringGrid.Cells[0,0] := Inf[11];
      StringGrid.Cells[1,0] := Inf[0]+#176;
      StringGrid.Cells[2,0] := Inf[1]+#176;
      StringGrid.Cells[3,0] := Inf[17];
    end;
  end;
end;

procedure SaveGrid(FN:String; SG:TStringGrid);
var I, J :Integer;
    S :TStringList;
begin

   if ExtractFileExt(FN) = '' then
      FN := FN + '.txt';

   S := TStringList.Create;
     For I := 1 To SG.RowCount-1 Do
     Begin
       S.Add('');
       for J := 0 to SG.ColCount-1 do
       begin
         if J > 0 then
            S[S.Count-1] := S[S.Count-1] + #$9;
         S[S.Count-1] := S[S.Count-1] + SG.Cells[j, i];
       end;
    End;
   S.SaveToFile(FN);
   S.Free;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TLocForm.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key= vk_Tab) or (Key = vk_Return) then
   TabStringGrid(StringGrid1);
 if (Key= vk_Delete) or (Key = vk_Back) then
   DelStringGrid(StringGrid1);
end;

procedure TLocForm.StringGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key = vk_Tab) or (Key = vk_Return) then
   TabStringGrid(StringGrid2);
 if (Key= vk_Delete) or (Key = vk_Back) then
   DelStringGrid(StringGrid2);
end;

procedure TLocForm.FormActivate(Sender: TObject);
var I :integer;
begin

 ClearGrid(StringGrid1);
 ClearGrid(StringGrid2);
// RenameTabs(StringGrid1,RadioGroup1.ItemIndex);
// RenameTabs(StringGrid2,RadioGroup2.ItemIndex);

  CSCat.Clear;
  for i := 0 to Length(CoorinateSystemCategories)-1 do
     CSCat.Items.Add(CoorinateSystemCategories[i]);

   CSCat.Sorted := true;

   For I := CSCat.Items.Count DownTo 1 Do
     if CSCat.Items[I] = CSCat.Items[I-1] then
        CSCat.Items.Delete(I);

   CSCat.ItemIndex := 0;
   CSCat.OnChange(nil);
   PrepareComboBox(CSCat);
   PrepareComboBox(MB);

   CSNum.OnChange(nil);
   
end;

procedure FindCat(Cat: String; CSs: TComboBox);
var i: integer;
begin
 CSs.Items.Clear;
 for i := 0 to Length( CoordinateSystemList)-1 do
  if CoordinateSystemList[i].Category = Cat then
    CSs.Items.Add(CoordinateSystemList[i].Caption);
end;

procedure TLocForm.CSCatChange(Sender: TObject);
begin
  FindCat(CSCat.Items[CSCat.ItemIndex], CSNum);
  CSNum.ItemIndex := 0;

  HintComboBox(CSCat);

  PrepareComboBox(CSNum);
  CSNum.OnChange(nil);
end;

procedure TLocForm.CSNumChange(Sender: TObject);
 var i, CoordType : integer;
begin
  HintComboBox(CSNum);

  if CSNum.ItemIndex <= -1 then
      exit;

  i := FindCoordinateSystemByCaption(CSNum.Items[CSNum.ItemIndex]);
  CoordType := CoordinateSystemList[i].ProjectionType;
  RenameTabs(StringGrid1, CoordType);

  CheckBox2.Visible := CoordType < 2;

  LocalizationFm.ChoosedCS := I;
end;

procedure TLocForm.MBChange(Sender: TObject);
begin
  HintComboBox(MB);
end;

procedure TLocForm.Load1Click(Sender: TObject);
begin
  if OpenDialog1.Execute() then
  with OpenTabFm do
  begin;
     isLeftTab  := True;

     FileToLoad := LocForm.OpenDialog1.FileName;
     ShowModal;
  end;
end;

{procedure InitLang(Lang:String);
var S:TstringList;
    I:Integer;
begin
  S := TStringList.Create;
  S.LoadFromFile('Data\Languages\'+Lang+'\GeoInfo.txt');
  For I := 0 To S.Count-1 Do
    if i < Length(Inf)-1 then
       Inf[I] := S[I]
         else
           break;
  S.Free;
end;  }

procedure TLocForm.FormCreate(Sender: TObject);
begin
  //initLang('Russian');
  //RenameTabs(StringGrid2, 1);
  InitDir :=  Form1.MyDir;
end;

procedure TLocForm.Load2Click(Sender: TObject);
begin
  if OpenDialog1.Execute() then
  with OpenTabFm do
  begin;
     isLeftTab  := False;
     FileToLoad := LocForm.OpenDialog1.FileName;
     ShowModal;
  end;
end;

procedure TLocForm.Clear1Click(Sender: TObject);
begin
  ClearGrid(StringGrid1);
end;

procedure TLocForm.Clear2Click(Sender: TObject);
begin
  ClearGrid(StringGrid2);
end;

procedure TLocForm.Save1Click(Sender: TObject);
begin
  if SaveDialog1.Execute() then
  begin
     if fileexists(SaveDialog1.FileName) then
       if MessageDLG(Inf[33], mtConfirmation, [mbYes, mbNo],0) <> 6 then
         exit;

     SaveGrid(SaveDialog1.FileName, StringGrid1);
  end;
end;

procedure TLocForm.Save2Click(Sender: TObject);
begin
  if SaveDialog1.Execute() then
  begin
     if fileexists(SaveDialog1.FileName) then
       if MessageDLG(Inf[33], mtConfirmation, [mbYes, mbNo],0) <> 6 then
         exit;

     SaveGrid(SaveDialog1.FileName, StringGrid2);
  end;
end;

procedure TLocForm.Button1Click(Sender: TObject);
var
  ErrLim    :Double;
  PtsCount  :Integer;
  I, J      :Integer;
begin
  SetCurrentDir(InitDir);

  ErrLim := StrToFloat2(ErrLimit.Text);
  if ErrLim = 0 then
    if MessageDlg(Inf[34],MtError,[MbOk],0) = 1 then
       exit;

  i := FindCoordinateSystemByCaption(CSNum.Items[CSNum.ItemIndex]);
  if I=-1 then
    if MessageDlg(Inf[43],MtError,[MbOk],0) = 1 then
       exit;
  if CoordinateSystemList[I].isLocalized  then
    if MessageDlg(Inf[61],MtError,[MbOk],0) = 1 then
       exit;

  StringGrid2.RowCount := StringGrid2.RowCount + 1;

  PtsCount := 0;
  For I := 1 To StringGrid1.RowCount -1 Do
  Begin
     if (StringGrid1.Cells[0,I] = '') or (StringGrid1.Cells[0,I] = ' ') then
        continue;

     for J := I To StringGrid2.RowCount -1 Do
        if AnsiLowerCase(StringGrid2.Cells[0,J]) =
           AnsiLowerCase(StringGrid1.Cells[0,I]) then
        Begin
          StringGrid2.Rows[StringGrid2.RowCount - 1] := StringGrid2.Rows[I];
          StringGrid2.Rows[I] := StringGrid2.Rows[J];
          StringGrid2.Rows[J] := StringGrid2.Rows[StringGrid2.RowCount - 1];

          inc(PtsCount);
          Break;
        End;

  End;
  
  StringGrid2.RowCount := StringGrid2.RowCount - 1;

  if PtsCount <= 2 then
    if MessageDlg(Inf[35],MtError,[MbOk],0) = 1 then
       exit;

  LocalizationFm.ErrLim := ErrLim;
  LocalizationFm.SameHgt := SH.Checked;
  LocalizationFm.ConstScale := Sc1.Checked;
  LocalizationFm.isLeft := PlanKind.ItemIndex = 1;
  ClearGrid(LocalizationFm.MainGrid);
  LocalizationFm.MainGrid.RowCount := PtsCount +1;

  for J := 0 to 3 do
  Begin
    LocalizationFm.MainGrid.Cells[J+1,0] := StringGrid1.Cells[J,0];
    if J > 0 then
       LocalizationFm.MainGrid.Cells[J+4,0] := StringGrid2.Cells[J,0];
  End;
  LocalizationFm.MainGrid.Cells[0,0] := Inf[36];

  PtsCount := 0;
  For I := 1 To StringGrid1.RowCount -1 Do
  Begin
     if StringGrid1.Cells[0,I] = '' then
        continue;

     if AnsiLowerCase(StringGrid2.Cells[0,I]) =
        AnsiLowerCase(StringGrid1.Cells[0,I]) then
        Begin
           Inc(PtsCount);
           LocalizationFm.MainGrid.Cells[1,PtsCount] := StringGrid1.Cells[0,I];
           for J := 1 to 3 do
           Begin
              LocalizationFm.MainGrid.Cells[J+1,PtsCount] := StringGrid1.Cells[J,I];
              LocalizationFm.MainGrid.Cells[J+4,PtsCount] := StringGrid2.Cells[J,I];
           End;
        End;

  End;
  LocalizationFm.ShowModal;

end;

procedure TLocForm.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
   DrawCellPlus(StringGrid1, ACol, ARow, Rect, State, 1);
end;

procedure TLocForm.StringGrid2DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
   DrawCellPlus(StringGrid2, ACol, ARow, Rect, State, 1);
end;

procedure TLocForm.FormShow(Sender: TObject);
begin
  RenameTabs(StringGrid2, 1);
  InitDir :=  Form1.MyDir;

  MB.Items[0] := inf[48];
  PlanKind.Items[0] := inf[49];
  PlanKind.Items[1] := inf[50];
  PlanKind.ItemIndex := 1;
  MB.ItemIndex := 0;
end;

end.
