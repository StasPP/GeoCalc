unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,LangLoader, StdCtrls, ExtCtrls;

type
  TForm6 = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    Aim :integer;
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses GeoFunctions, GeoClasses, MainForm, Unit2;
{$R *.dfm}

procedure TForm6.Button1Click(Sender: TObject);
begin
SaveLngs;
end;

procedure TForm6.Edit1Change(Sender: TObject);
var I:Integer;
begin
 if Edit1.Text = '' then
   exit;

 ListBox1.Items.Clear;

 for i := 0 to Length(CoordinateSystemList)-1 do
 Begin
    if Pos(AnsiLowerCase(Edit1.Text),AnsiLowerCase(CoordinateSystemList[i].Caption))>0 then
    Begin
      ListBox1.Items.Add(CoordinateSystemList[i].Caption);
    End;
 End;
end;

procedure TForm6.ListBox1DblClick(Sender: TObject);
var CSN :Integer;
    CatN : string;
    i : integer;
begin
  if ListBox1.ItemIndex >-1 then
  Begin
    CSN := FindCoordinateSystembyCaption(ListBox1.Items[ListBox1.ItemIndex]);

    if CSN =-1 then
       exit;

    case AIM of
      1: begin
        for I := 0 to Form1.ComboBox1.Items.Count -1 do
           if Form1.ComboBox1.Items[I] = CoordinateSystemList[CSN].Category then
           Begin
              Form1.ComboBox1.ItemIndex := i;
              Form1.ComboBox1.OnChange(nil);
              break;
           End;

        for I := 0 to Form1.ListBox4.Items.Count - 1 do
         if Form1.ListBox4.Items[I] = CoordinateSystemList[CSN].Caption then
         Begin
            Form1.ListBox4.ItemIndex := i;
            break;
         End;
      end;

      2: begin
        for I := 0 to Form1.ComboBox2.Items.Count -1 do
           if Form1.ComboBox2.Items[I] = CoordinateSystemList[CSN].Category then
           Begin
              Form1.ComboBox2.ItemIndex := i;
              Form1.ComboBox2.OnChange(nil);
              break;
           End;

        for I := 0 to Form1.ListBox5.Items.Count - 1 do
         if Form1.ListBox5.Items[I] = CoordinateSystemList[CSN].Caption then
         Begin
            Form1.ListBox5.ItemIndex := i;
            break;
         End;
      end;
      3: begin
         for I := 0 to Form2.ComboBox2.Items.Count -1 do
           if Form2.ComboBox2.Items[I] = CoordinateSystemList[CSN].Category then
           Begin
              Form2.ComboBox2.ItemIndex := i;
              Form2.ComboBox2.OnChange(nil);
              break;
           End;

         for I := 0 to Form2.ListBox4.Items.Count - 1 do
         if Form2.ListBox4.Items[I] = CoordinateSystemList[CSN].Caption then
         Begin
            Form2.ListBox4.ItemIndex := i;
            break;
         End;

      end;
    end;
  End;
  close;
end;

end.
