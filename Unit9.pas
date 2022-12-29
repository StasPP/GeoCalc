unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, LangLoader, GeoFunctions, GeoFiles, GeoClasses,
  ExtCtrls, Geoid;

type
  TForm9 = class(TForm)
    GroupBox1: TGroupBox;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SpeedButton2: TSpeedButton;
    GroupBox2: TGroupBox;
    SpeedButton3: TSpeedButton;
    Label11: TLabel;
    Label16: TLabel;
    GroupBox3: TGroupBox;
    SpeedButton4: TSpeedButton;
    Label12: TLabel;
    Label13: TLabel;
    GroupBox4: TGroupBox;
    SpeedButton5: TSpeedButton;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    LangBox: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LangBoxChange(Sender: TObject);
    procedure RefreshLabels;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;
  Inited: boolean = false;
implementation

uses MainForm, Unit3, LocFm, Unit4, Unit5, Unit7;

{$R *.dfm}

procedure TForm9.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.close;
end;

procedure TForm9.FormShow(Sender: TObject);
var I, gk, mkt, loc:Integer;
begin
  

  Form1.Init;     

  if not Inited then
  begin
    LangBox.Items := Form1.LangBox.Items;
    LangBox.ItemIndex := Form1.LangBox.ItemIndex; 
    Inited := true;
  end;
  
  LoadLang(True);
  Form1.ReInit;
  RefreshLabels;
  Repaint;
end;

procedure TForm9.LangBoxChange(Sender: TObject);
begin
  Form1.LangBox.ItemIndex :=  LangBox.ItemIndex;
  Form1.LangBox.OnChange(nil);
  RefreshLabels;
end;

procedure TForm9.RefreshLabels;
var I, gk, mkt, loc:Integer;
begin
  Label6.Caption := IntToStr(Length(CoordinateSystemList));
  gk := 0; mkt:= 0; loc := 0;
  for I := 0 to Length(CoordinateSystemList) - 1 do
  begin
     case CoordinateSystemList[I].ProjectionType of
        2: inc(gk);
        3,4 : inc(mkt);
     end;
     if CoordinateSystemList[I].isLocalized then
       inc(loc);
  end;
  Label7.Caption := IntToStr(gk); Label8.Caption := IntToStr(mkt);
  Label9.Caption := IntToStr(loc);
  Label10.Caption := IntToStr(Length(CoordinateSystemList) - gk - mkt - loc);

  Label16.Caption := IntToStr(Length(DatumList));
  Label13.Caption := IntToStr(Length(EllipsoidList));
  Label15.Caption := IntToStr(Length(GeoidsMetaData));
end;

procedure TForm9.SpeedButton1Click(Sender: TObject);
var I:Integer;
begin
  Form3.Combobox1.Clear;
  for i := 0 to Length(DatumList)-1 do
     Form3.Combobox1.Items.Add(DatumList[i].Caption);
  Form3.ComboBox3.Items := Form1.ComboBox1.Items;
  Form3.Edit4.Items := Form1.ComboBox1.Items;
  Form3.ComboBox3.ItemIndex := 0; // Form1.ComboBox1.ItemIndex;
  Form3.ComboBox3.OnChange(nil);
  Form3.ListBox1.ItemIndex := Form1.ListBox4.ItemIndex;
  Form3.ListBox1.OnClick(nil);
  

  Form3.Showmodal;
  FormShow(nil);
  LangBox.OnChange(nil);
end;

procedure TForm9.SpeedButton2Click(Sender: TObject);
begin
  LocForm.ShowModal;
  FormShow(nil);
  LangBox.OnChange(nil);
end;

procedure TForm9.SpeedButton3Click(Sender: TObject);
var I:Integer;
begin
   Form4.ListBox1.Items := Form1.ListBox1.Items;
   Form4.ListBox1.ItemIndex := 0; //Form1.ListBox1.ItemIndex;
   Form4.ComboBox1.Clear;
   for i := 0 to Length(EllipsoidList)-1 do
     Form4.Combobox1.Items.Add(EllipsoidList[i].Caption);
   Form4.ListBox1.OnClick(nil);


   Form4.Showmodal;
   FormShow(nil);
   LangBox.OnChange(nil);
end;

procedure TForm9.SpeedButton4Click(Sender: TObject);
begin
  Form5.RefreshList;
  Form5.ListBox1.ItemIndex := 0; //Form1.ComboBox1.ItemIndex;
  Form5.ListBox1.OnClick(nil);
  Form5.ShowModal;
  FormShow(nil);
  LangBox.OnChange(nil);
end;

procedure TForm9.SpeedButton5Click(Sender: TObject);
begin
  Form7.Button1.Hide;
  Form7.Button2.Hide;
  Form7.Showmodal;
  LangBox.OnChange(nil);
end;

end.
