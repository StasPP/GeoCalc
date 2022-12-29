program Geo;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  GeoFunctions in 'GeoToolsUnits\GeoFunctions.pas',
  GeoMath in 'GeoToolsUnits\GeoMath.pas',
  GeoFiles in 'GeoToolsUnits\GeoFiles.pas',
  GeoClasses in 'GeoToolsUnits\GeoClasses.pas',
  GeoString in 'GeoToolsUnits\GeoString.pas',
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  Unit5 in 'Unit5.pas' {Form5},
  LangLoader in 'LangLoader.pas',
  Unit6 in 'Unit6.pas' {Form6},
  Unit7 in 'Unit7.pas' {Form7},
  LoadFm in 'LoadFm.pas' {OpenTabFm},
  LocFm in 'LocFm.pas' {LocForm},
  LocMain in 'LocMain.pas' {LocalizationFm},
  USaveLocaliz in 'USaveLocaliz.pas' {SaveLoc},
  GeoLocalization in 'GeoToolsUnits\GeoLocalization.pas',
  Unit8 in 'Unit8.pas' {Form8},
  Unit9 in 'Unit9.pas' {Form9},
  CoderCheck in 'CoderCheck.pas';

{$R *.res}

 procedure SetAsMain(aForm:TForm);
 var P:Pointer;
 begin
    P := @Application.MainForm;
    Pointer(P^) := aForm;
 end;

begin
  Application.Initialize;
  Application.Title := 'GeoCalculator';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TOpenTabFm, OpenTabFm);
  Application.CreateForm(TLocForm, LocForm);
  Application.CreateForm(TLocalizationFm, LocalizationFm);
  Application.CreateForm(TSaveLoc, SaveLoc);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  if ParamStr(1)='-ed' then
    SetAsMain(Form9);

  Application.Run;
 
end.
