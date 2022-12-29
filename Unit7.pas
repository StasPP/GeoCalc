unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls, Geoid;

type
  TForm7 = class(TForm)
    Image1: TImage;
    Bevel1: TBevel;
    ListBox1: TListBox;
    Edit1: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    Edit2: TEdit;
    Label6: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Memo1: TMemo;
    Shape1: TShape;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Side: Boolean;
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

uses MainForm;

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
  case Side of
    true  : Form1.Geoid1.ItemIndex := ListBox1.ItemIndex + 1;
    false : Form1.Geoid2.ItemIndex := ListBox1.ItemIndex + 1;
  end;
  close;
end;

procedure TForm7.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_return then
    Button2.Click;
end;

procedure TForm7.FormShow(Sender: TObject);
var I:Integer;
begin
  ListBox1.Clear;
  for I := 0 To Length(GeoidsMetaData)-1 Do
    ListBox1.Items.Add(GeoidsMetaData[I].Caption);
  ListBox1.ItemIndex := 0;
  ListBox1.OnClick(nil);
end;

procedure TForm7.ListBox1Click(Sender: TObject);
begin

  if  ListBox1.ItemIndex < 0 then
    exit;

  with GeoidsMetaData[ListBox1.ItemIndex] do
  begin
    Shape1.Left := Image1.Left + trunc(L1) + 180;
    Shape1.Width :=  trunc(L2 - L1);

    Shape1.Top := Image1.Top +  trunc(-B1) + 90;
    Shape1.Height := trunc(B1 - B2);

    Edit1.Text := NameId;
    Edit2.Text := Caption;
    Edit3.Text := FileName;
    Memo1.Lines.Clear;
    Memo1.Lines.Add(Discription);
    SendMessage(Memo1.Handle,WM_VSCROLL, SB_TOP, 0);
  end;

end;

end.
