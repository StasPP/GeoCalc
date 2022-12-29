unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TForm8 = class(TForm)
    CheckBox4: TCheckBox;
    GroupBox1: TGroupBox;
    RS1: TRadioButton;
    RS2: TRadioButton;
    GroupBox2: TGroupBox;
    ShowLitera: TCheckBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    ComboBox5: TComboBox;
    Button1: TButton;
    Button2: TButton;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    ComboBox6: TComboBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

uses MainForm;

{$R *.dfm}

procedure TForm8.Button1Click(Sender: TObject);
begin
  Form1.CheckBox4.Checked   := CheckBox4.Checked;
  Form1.ShowLitera.Checked  := ShowLitera.Checked;
  Form1.RS1.Checked         := RS1.Checked;
  Form1.RS2.Checked         := RS2.Checked;
  Form1.ComboBox3.ItemIndex := ComboBox3.ItemIndex;
  Form1.ComboBox4.ItemIndex := ComboBox4.ItemIndex;
  Form1.ComboBox5.ItemIndex := ComboBox5.ItemIndex;
  Form1.ComboBox6.ItemIndex := ComboBox6.ItemIndex;

  Form1.ComboBox4.OnChange(nil);
  Form1.ComboBox3.OnChange(nil);
  close;
end;

procedure TForm8.Button2Click(Sender: TObject);
begin
 close;
end;

end.
