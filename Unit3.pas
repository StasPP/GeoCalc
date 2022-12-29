unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls, GeoClasses, GeoString, GeoFiles, LangLoader;

type
  TForm3 = class(TForm)
    ComboBox1: TComboBox;
    ListBox1: TListBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Label4: TLabel;
    ComboBox2: TComboBox;
    Label5: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ComboBox3: TComboBox;
    ValueList: TStringGrid;
    Label6: TLabel;
    Edit3: TEdit;
    Label7: TLabel;
    Edit4: TComboBox;
    Button5: TButton;
    isLocal: TCheckBox;
    procedure Button4Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FindNew(Cat, Cap :String);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RefreshLists;
    procedure Button1Click(Sender: TObject);
    procedure ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  oldidx : integer = -1;

implementation

uses MainForm, Unit4;

{$R *.dfm}

procedure TForm3.Button4Click(Sender: TObject);
begin
 ListBox1.OnClick(nil);
end;

procedure TForm3.ComboBox2Change(Sender: TObject);
var PrjType, SK, i: integer;
begin

 PrjType := ComboBox2.ItemIndex;
 Valuelist.RowCount:=1;

 Valuelist.ColWidths[0] := 180;
 Valuelist.ColWidths[1] :=  Valuelist.Width - 185;
 Valuelist.Enabled := true;

   case PrjType of

    2,3,4: begin
      Valuelist.RowCount := 5;
      Valuelist.FixedCols := 1;

      ValueList.Cells[0,0]:=  inf[18];
      ValueList.Cells[0,1]:=  inf[19];
      ValueList.Cells[0,2]:=  inf[20];
      ValueList.Cells[0,3]:=  inf[21];
      ValueList.Cells[0,4]:=  inf[22];

      if isLocal.Checked then
      begin
        Valuelist.RowCount := 11;
        ValueList.Cells[0,5]:=  inf[55];
        ValueList.Cells[0,6]:=  inf[56];
        ValueList.Cells[0,7]:=  inf[57];
        ValueList.Cells[0,8]:=  inf[58];
        ValueList.Cells[0,9]:=  inf[59];
        ValueList.Cells[0,10]:= inf[60];
      end;

    end;

    0,1: begin
      Valuelist.FixedCols := 1;
      Valuelist.Enabled := false;
      ValueList.Cells[0,0]:= '';
      ValueList.Cells[1,0]:= '';
    end;

  end;

  if Valuelist.Enabled then
  Begin
      SK := FindCoordinateSystemByCaption(ListBox1.Items[ListBox1.ItemIndex]);
      if SK<>-1 then
        for i := 0 to ValueList.RowCount do
          if i<= length(CoordinateSystemList[SK].Parameters)-1 then
            ValueList.Cells[1,i]:= FloatToStr(CoordinateSystemList[SK].Parameters[i])
              else
                ValueList.Cells[1,i]:= '0';
  End;
end;

procedure TForm3.ComboBox3Change(Sender: TObject);
begin
  if ComboBox3.ItemIndex<>-1 then
    Form1.findCat(ComboBox3.Items[ComboBox3.ItemIndex], Form3.ListBox1);
  Form3.ListBox1.ItemIndex:=0;
  Form3.ListBox1.OnClick(nil);
end;

procedure TForm3.ListBox1Click(Sender: TObject);
var SK, i :integer;
begin
  if ListBox1.ItemIndex <= -1 then
    exit;

  SK := FindCoordinateSystemByCaption(ListBox1.Items[ListBox1.ItemIndex]);

  if SK=-1 then
    exit;

  Button3.Enabled := true;
  Button4.Enabled := true;
  Button5.Enabled := true;

  Edit1.Text := CoordinateSystemList[SK].Name;
  Edit2.Text := CoordinateSystemList[SK].Caption;
  Edit3.Text := CoordinateSystemList[SK].FileName;
  Edit4.Text := CoordinateSystemList[SK].Category;

  isLocal.Checked := CoordinateSystemList[SK].isLocalized;

  ComboBox1.ItemIndex := CoordinateSystemList[SK].DatumN;

  Combobox2.ItemIndex := CoordinateSystemList[SK].ProjectionType;
  Combobox2.OnChange(nil);

  for i := 0 to length(CoordinateSystemList[SK].Parameters)-1 do
    if i <= Valuelist.RowCount-1 then
       ValueList.Cells[1,i]:= FloatToStr(CoordinateSystemList[SK].Parameters[i]);
end;

procedure TForm3.Button2Click(Sender: TObject);
var i, j : integer;
    FileName, dir: string;
    CS :TCoordinateSystem;
    ParNames : TStringList;
begin
  j := 0;
  for i := 0 to Length(CoordinateSystemList)-1 do
    if (CoordinateSystemList[i].Name = Edit1.Text)or(CoordinateSystemList[i].Caption = Edit2.Text) then
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
      break;
    end;

  i := 1;
  repeat
    FileName:= dir + 'User' + IntToStr(i)+'.txt';
    inc(i);
  until Fileexists(FileName) = false;

  Edit3.Text := Filename;

  CS.Name := Edit1.Text;
  CS.Caption := Edit2.Text;
  CS.Category := Edit4.Text;
  CS.ProjectionType := ComboBox2.ItemIndex;
  CS.DatumN := ComboBox1.ItemIndex;
  CS.FileName := FileName;
  ParNames := TStringList.Create;
  if ValueList.Enabled then
  Begin
    SetLength(CS.Parameters,ValueList.RowCount);
    for i := 0 to ValueList.RowCount-1 do
    begin
      ParNames.Add(ValueList.Cells[0,i]);
      CS.Parameters[i] := StrToFloat2(ValueList.Cells[1,i]);
    end;
  end;

  SaveCoordinateSystemToFile(Filename, CS, ParNames);

  FindNew(CS.Category, CS.Caption);

  Parnames.Destroy;
end;

procedure TForm3.Button3Click(Sender: TObject);
var i, j, Current : integer;
    FileName, dir: string;
    CS :TCoordinateSystem;
    ParNames : TStringList;
begin
  j := 0;
  Current := FindCoordinateSystemByCaption(ListBox1.Items[ListBox1.ItemIndex]);
  for i := 0 to Length(CoordinateSystemList)-1 do
    if ( (CoordinateSystemList[i].Name = Edit1.Text)
        or (CoordinateSystemList[i].Caption = Edit2.Text) )
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

  ForceDirectories(dir+ 'Backup\');
  CopyFile(PChar(Edit3.Text), PChar(dir+ 'Backup\' + Filename), false);

  FileName := Edit3.Text;

  CS.Name := Edit1.Text;
  CS.Caption := Edit2.Text;
  CS.Category := Edit4.Text;
  CS.ProjectionType := ComboBox2.ItemIndex;
  CS.DatumN := ComboBox1.ItemIndex;
  CS.FileName := FileName;
  ParNames := TStringList.Create;
  if ValueList.Enabled then
  Begin
    SetLength(CS.Parameters,ValueList.RowCount);
    for i := 0 to ValueList.RowCount-1 do
    begin
      ParNames.Add(ValueList.Cells[0,i]);
      CS.Parameters[i] := StrToFloat2(ValueList.Cells[1,i]);
    end;
  end;

  DeleteCoordinateSystem(Current);
  SaveCoordinateSystemToFile(Filename, CS, ParNames);

  FindNew(CS.Category, CS.Caption);

  Parnames.Destroy;
end;

procedure TForm3.FindNew(Cat, Cap: String);
var i: integer;
begin
  Combobox3.Items.Clear;
  
  for i := 0 to Length(CoorinateSystemCategories)-1 do
      Combobox3.Items.Add(CoorinateSystemCategories[i]);

  for i :=0 to Combobox1.Items.Count - 1 do
      if ComboBox3.Items[i] = Cat then
      begin
        ComboBox3.ItemIndex := i;
        break;
      end;
  ComboBox3.OnChange(nil);

  for i :=0 to ListBox1.Items.Count-1 do
      if ListBox1.Items[i]=Cap then
      begin
        ListBox1.ItemIndex := i;
        break;
      end;
  ListBox1.OnClick(nil);    
end;

procedure TForm3.Button5Click(Sender: TObject);
var j : integer;
    FileName, dir: string;

begin

  dir := '';
  for j:= length(Edit3.Text) downto 0 do
    if Edit3.Text[j]='\' then
    begin
      dir := Copy(Edit3.Text,1,j);
      FileName := Copy(Edit3.Text,j+1,Length(Edit3.Text)-j);
      break;
    end;

  ForceDirectories(dir+ 'Deleted\');
  CopyFile(PChar(Edit3.Text), PChar(dir+ 'Deleted\' + Filename), false);
  DeleteFile(PChar(Edit3.Text));

  Button3.Enabled := false;
  Button4.Enabled := false;
  Button5.Enabled := false;

  DeleteCoordinateSystem(FindCoordinateSystemByCaption(ListBox1.Items[ListBox1.ItemIndex]));
  ComboBox3.OnChange(nil);

end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.ReInit;
end;

procedure TForm3.RefreshLists;
var i: integer;
begin
  SetCurrentDir(Form1.MyDir);
  ComboBox1.Clear;
  for i := 0 to Length(DatumList)-1 do
     Combobox1.Items.Add(DatumList[i].Caption);
     
  ComboBox3.OnChange(nil);
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  Form4.RefreshLists;
  Form4.ListBox1.ItemIndex := ComboBox1.ItemIndex;
  Form4.ListBox1.OnClick(nil);
  Form4.ShowModal;
end;

procedure TForm3.ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  idx : Longint;
begin
  with Sender as TListBox do begin
    idx := ItemAtPos(Point(x,y),True);
    if (idx < 0) or (idx = oldidx) then
      Exit;

    Application.ProcessMessages;
    Application.CancelHint;

    oldidx := idx;

    HintX := TListBox(Sender).itemRect(idx).Left;
    HintY := TListBox(Sender).itemRect(idx).Top;

    Hint := '';
    if Canvas.TextWidth(Items[idx]) > Width - 24 then
      Hint:=Items[idx];
  end;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  SetCurrentDir(Form1.MyDir);
end;

procedure TForm3.FormShow(Sender: TObject);
begin
 ListBox1.OnClick(nil);
end;

end.
