unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, GeoClasses, GeoFiles, GeoString, LangLoader;

type
  TForm5 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label6: TLabel;
    Edit3: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label4: TLabel;
    procedure ListBox1Click(Sender: TObject);
    procedure RefreshList;
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses Unit4, Unit3, MainForm;

{$R *.dfm}

procedure TForm5.ListBox1Click(Sender: TObject);
var El: Integer;
begin
 if ListBox1.ItemIndex = -1 then
    exit;

 El := FindEllipsoidByCaption(ListBox1.Items[ListBox1.ItemIndex]);

 if El = -1 then Exit;

 Edit1.Text := EllipsoidList[El].Name;
 Edit2.Text := EllipsoidList[El].Caption;
 Edit3.Text := EllipsoidList[El].FileName;

 Edit4.Text := FloatToStr(EllipsoidList[El].a);
 Edit5.Text := FloatToStr(1/EllipsoidList[El].alpha);

 Button1.Enabled := true;
 Button4.Enabled := true;
 Button2.Enabled := true;

end;


procedure TForm5.RefreshList;
var i:integer;
begin
  ListBox1.Clear;
  for i := 0 to length(EllipsoidList)-1 do
     ListBox1.Items.Add(EllipsoidList[i].Caption);
end;

procedure TForm5.Button4Click(Sender: TObject);
var dir, FileName: String;
    j :integer;
begin

  dir := '';
  for j := length(Edit3.Text) downto 0 do
    if Edit3.Text[j]='\' then
    begin
      dir := Copy(Edit3.Text,1,j);
      FileName := Copy(Edit3.Text,j+1,Length(Edit3.Text)-j);
      break;
    end;

  ForceDirectories(dir+ 'Deleted\');
  CopyFile(PChar(Edit3.Text), PChar(dir+ 'Deleted\' + Filename), false);
  DeleteFile(PChar(Edit3.Text));

  Button1.Enabled := false;
  Button4.Enabled := false;
  Button2.Enabled := false;

  DeleteEllipsoid(FindEllipsoidByCaption(ListBox1.Items[ListBox1.ItemIndex]));
  RefreshList;
  ListBox1.OnClick(nil);

end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 SetCurrentDir(Form1.MyDir);
 RefreshDatums;

 OldLang:='Russian';
 GeoTranslate(OldLang, Lang, 'Data\Languages\');

 Form4.RefreshLists;
 Form3.RefreshLists;
 Form1.ReInit;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  ListBox1.OnClick(nil);
end;

procedure TForm5.Button3Click(Sender: TObject);
var i, j, Current : integer;
    FileName, dir: string;
    NE : TEllipsoid;
begin

  j := 0;
  Current := FindEllipsoidByCaption(ListBox1.Items[ListBox1.ItemIndex]);

  for i := 0 to Length(EllipsoidList)-1 do
    if ( (EllipsoidList[i].Name = Edit1.Text)
        or (EllipsoidList[i].Caption = Edit2.Text) )
        and (i<>Current) then
           inc(j);

  if j >= 1 then
  begin
    MessageDlg(inf[31],mtError,[mbOk],6);
    exit;
  end;

  dir := '';
  for j:= length(Edit3.Text) downto 0 do
    if Edit3.Text[j]='\' then
    begin
      dir := Copy(Edit3.Text,1,j);
      FileName := Copy(Edit3.Text,j+1,Length(Edit3.Text)-j);
      break;
    end;

  i := 1;
  repeat
    FileName:= dir + 'User' + IntToStr(i)+'.txt';
    inc(i);
  until Fileexists(FileName) = false;

  Edit3.Text := FileName;

  NE.Name := Edit1.Text;
  NE.Caption := Edit2.Text;

  NE.a := StrToFloat2(Edit4.Text);
  NE.alpha := 1/ StrToFloat2(Edit5.Text);

  NE.FileName := FileName;

  SaveEllipsoidToFile(FileName, NE);

  RefreshList;
  for i := 0 to ListBox1.Count-1 do
    if ListBox1.Items[i] = NE.Caption then
    begin
      ListBox1.ItemIndex := i;
      ListBox1.OnClick(nil);
      break;
    end;
end;

procedure TForm5.Button1Click(Sender: TObject);
var i, j, Current : integer;
    FileName, dir: string;
    NE : TEllipsoid;
begin

  j := 0;
  Current := FindEllipsoidByCaption(ListBox1.Items[ListBox1.ItemIndex]);

  for i := 0 to Length(EllipsoidList)-1 do
    if ( (EllipsoidList[i].Name = Edit1.Text)
        or (EllipsoidList[i].Caption = Edit2.Text) )
        and (i<>Current) then
           inc(j);

  if j >= 1 then
  begin
    MessageDlg('��� ��� �������� �� �������� ����������. ������� ������',mtError,[mbOk],6);
    exit;
  end;

  dir := '';
  for j:= length(Edit3.Text) downto 0 do
    if Edit3.Text[j]='\' then
    begin
      dir := Copy(Edit3.Text,1,j);
      FileName := Copy(Edit3.Text,j+1,Length(Edit3.Text)-j);
      break;
    end;

  ForceDirectories(dir+ 'Backup\');
  CopyFile(PChar(Edit3.Text), PChar(dir+ 'Backup\' + Filename), false);

  FileName := Edit3.Text;


  NE := EllipsoidList[Current];

  NE.Name := Edit1.Text;
  NE.Caption := Edit2.Text;

  NE.a := StrToFloat2(Edit4.Text);
  NE.alpha := 1/ StrToFloat2(Edit5.Text);

  NE.FileName := FileName;


  DeleteEllipsoid(Current);
  SaveEllipsoidToFile(FileName, NE);

  RefreshList;
  for i := 0 to ListBox1.Count-1 do
    if ListBox1.Items[i] = NE.Caption then
    begin
      ListBox1.ItemIndex := i;
      ListBox1.OnClick(nil);
      break;
    end;
end;

procedure TForm5.FormActivate(Sender: TObject);
begin
  SetCurrentDir(Form1.MyDir);
end;

procedure TForm5.FormShow(Sender: TObject);
begin
 if ListBox1.ItemIndex = -1 then
    ListBox1.ItemIndex := 0;
 ListBox1.OnClick(nil);
end;

end.
