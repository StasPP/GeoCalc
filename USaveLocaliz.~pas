unit USaveLocaliz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Grids, ValEdit, GeoClasses,  LangLoader,
  GeoFunctions, GeoFiles;

type
  TSaveLoc = class(TForm)
    ValueList: TValueListEditor;
    Edit1: TEdit;
    PlanKind: TComboBox;
    Edit2: TEdit;
    SaveButton: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit4: TEdit;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label4: TLabel;
    CloseButton: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Label8: TLabel;
    procedure CloseButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    PScale, PBeta, Px, Py, Pz : Boolean;

  end;

var
  SaveLoc: TSaveLoc;

implementation

uses LocMain, LocFm, MainForm;

{$R *.dfm}

procedure TSaveLoc.CloseButtonClick(Sender: TObject);
begin
  close;
end;

procedure SaveLocCS (FN:String);
var S: TStringList;
    Str: array [1..10] of string;
begin

  with LocalizationFm do
  if ChoosedDatum = -1 then
  Begin
    Str[1] := DatumList[CoordinateSystemList[ChoosedCS].DatumN].Name ;
    Str[2] := ProjectionNames[CoordinateSystemList[ChoosedCS].ProjectionType];
    Str[3] := FloatToStr(CoordinateSystemList[ChoosedCS].Parameters[0]);
    Str[4] := FloatToStr(CoordinateSystemList[ChoosedCS].Parameters[1]);
    Str[5] := FloatToStr(CoordinateSystemList[ChoosedCS].Parameters[2]);
    Str[6] := FloatToStr(CoordinateSystemList[ChoosedCS].Parameters[3]);
    Str[7] := FloatToStr(CoordinateSystemList[ChoosedCS].Parameters[4]);
  End
    Else
      Begin
         Str[1] := DatumList[ChoosedDatum].Name;
         Str[2] := ProjectionNames[ChoosedProj];

         case ChoosedProj of
           2 :   Str[3] := IntToStr(6 * ChoosedZone - 3);
           3,4 : Str[3] := IntToStr(6 * ChoosedZone - 3 - 180);
         end;

         Str[4] := '0';
         case ChoosedProj of
           2 :   Str[5] := '1';
           3,4 : Str[5] := '0.9996';
         end;
         Str[6] := IntToStr(ChoosedZone*1000000 + 500000);
         Str[7] := '0';
      End;

  S := TStringList.Create;

  S.Add('Имя:');
  S.Add(SaveLoc.Edit2.Text);
  S.Add('');

  S.Add('Название:');
  S.Add(SaveLoc.Edit4.Text);
  S.Add('');

  S.Add('Датум:');
  S.Add(str[1]);
  S.Add('');

  S.Add('Тип проекции:');
  S.Add(str[2]);
  S.Add('L');

  S.Add('Категория:');
  if SaveLoc.ComboBox1.Text= '' then
     S.Add('---')
       else
          S.Add(SaveLoc.ComboBox1.Text);
  S.Add('');

  S.Add('Начальный меридиан:');
  S.Add(str[3]);
  S.Add('');

  S.Add('Начальная широта:');
  S.Add(str[4]);
  S.Add('');

  S.Add('Масштаб:');
  S.Add(str[5]);
  S.Add('');

  S.Add('Условное смещение на Восток:');
  S.Add(str[6]);
  S.Add('');

  S.Add('Условное смещение на Север:');
  S.Add(str[7]);
  S.Add('');

  //////////////////// NEU! :3

  S.Add('Трансформация: тип СК');
  case LocalizationFm.isLeft of
    true:  S.Add('1');
    false: S.Add('0');
  end;
  S.Add('');


  with LocalizationFm do
  begin
    S.Add('Трансформация: масштаб');
    S.Add(FloatToStr(PScale));
    S.Add('');

    S.Add('Трансформация: поворот (рад.)');
    S.Add(FloatToStr(PBeta));
    S.Add('');

    S.Add('Трансформация: сдвиг X');
    S.Add(FloatToStr(PX));
    S.Add('');

    S.Add('Трансформация: сдвиг Y');
    S.Add(FloatToStr(PY));
    S.Add('');

    S.Add('Трансформация: сдвиг H');
    S.Add(FloatToStr(PZ));
    S.Add('');
  end;

  S.SaveToFile(FN);

  S.Free;
end;

procedure TSaveLoc.SaveButtonClick(Sender: TObject);
var FN, FDir :String;
    S: TStringList;
    i: integer;
begin
  S  := TStringList.Create;
  S.LoadFromFile('Data\Sources.loc');

  /// Проверить уникальность ID   /// Проверить уникальность Caption
  for I := 0 To Length(CoordinateSystemList)-1 Do
    if (CoordinateSystemList[I].Name = Edit2.Text) or
       (CoordinateSystemList[I].Caption = Edit4.Text) then
       if MessageDlg(inf[31],mtError,[mbOk],0) > -100 then
         exit;


  FDir := S[2];
  If FDir[Length(FDir)] <> '\' then
      FDir := FDir + '\';

  i := 1;
  repeat
    FN:= FDir + 'User' + IntToStr(i)+'.txt';
    inc(i);
  until Fileexists(FN) = false;


  S.Free;
  SaveLocCS(FN);
  LoadCoordinateSystemFromFile(FN);

  LocalizationFm.Close;
  LocForm.Close;
  
//  Form1.Init;
  Form1.Reinit;
  Form1.LangBox.OnChange(nil);

  close;
end;

end.
