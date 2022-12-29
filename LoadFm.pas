unit LoadFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, Spin, StdCtrls, ExtCtrls, TabFunctions, OutputPlus;

type
  TOpenTabFm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    StringGrid1: TStringGrid;
    SepG: TRadioGroup;
    Edit1: TEdit;
    ValueList: TValueListEditor;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    procedure ValueListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SepGClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RefreshRes;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure OpenTable(SG:TStringGrid);
    procedure Button1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    isLeftTab  :Boolean;
    FileToLoad :String;
    { Public declarations }
  end;

var
  OpenTabFm: TOpenTabFm;
  S: TStringList;
implementation

uses LocFm, MainForm;

{$R *.dfm}

procedure TOpenTabFm.ValueListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  RefreshRes;
end;

procedure TOpenTabFm.SepGClick(Sender: TObject);
begin
  Edit1.Visible := SepG.ItemIndex = 2;
  RefreshRes;
end;

procedure TOpenTabFm.FormShow(Sender: TObject);
var I :integer;
begin
  for I := 1 To 4 Do
    case isLeftTab of
      true:
        begin
          ValueList.Keys[I] := LocForm.StringGrid1.Cells[I-1,0];
          StringGrid1.Cells[I-1,0] := LocForm.StringGrid1.Cells[I-1,0];
        end;
      false:
        begin
           ValueList.Keys[I] := LocForm.StringGrid2.Cells[I-1,0];
           StringGrid1.Cells[I-1,0] := LocForm.StringGrid2.Cells[I-1,0];
        end;
    end;

   SetCurrentDir(Form1.MyDir);
   if Pos('xls', AnsiLowerCase(ExtractFileExt(FileToLoad))) > 0 then
   begin
       Form1.XlsToTXT(FileToLoad);
       FileToLoad := 'Data\Temp.txt';
       SepG.ItemIndex :=1;
   end;
   S.LoadFromFile(FileToLoad);

   RefreshRes;
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

procedure TOpenTabFm.RefreshRes;
var i, j, CoordType : integer;
    Sep : Char;
begin
  try
   ClearGrid(StringGrid1);

   for i:= SpinEdit1.Value-1 to S.count-1 do
   Begin
     if i<0 then
       continue;

     if i > 3 + (SpinEdit1.Value-1) then exit;

     with StringGrid1 do
        RowCount := 5;


     if StringGrid1.RowCount > 1 then
       StringGrid1.FixedRows := 1;

     sep:=' ';
     case SepG.ItemIndex of
        0: sep:=' ';
        1: sep:=#$9;
        2: if Edit1.Text<> '' then sep := Edit1.Text[1];
        3: sep:=';';
        4: sep:=',';
     end;

     StringGrid1.Cells[0,i+1-(SpinEdit1.Value-1)] := GetCols(s[i], StrToInt(ValueList.Cells[1,1])-1, 1, sep, false);
     StringGrid1.Cells[1,i+1-(SpinEdit1.Value-1)] := GetCols(s[i], StrToInt(ValueList.Cells[1,2])-1, 1, sep, true);
     StringGrid1.Cells[2,i+1-(SpinEdit1.Value-1)] := GetCols(s[i], StrToInt(ValueList.Cells[1,3])-1, 1, sep, true);
     StringGrid1.Cells[3,i+1-(SpinEdit1.Value-1)] := GetCols(s[i], StrToInt(ValueList.Cells[1,4])-1, 1, sep, true);

   end;

   except
   end;
end;

procedure TOpenTabFm.FormCreate(Sender: TObject);
begin
  S := TStringList.Create;
end;

procedure TOpenTabFm.FormDestroy(Sender: TObject);
begin
  S.Free
end;

procedure TOpenTabFm.Edit1Change(Sender: TObject);
begin
  SepG.ItemIndex := 2;  
end;

procedure TOpenTabFm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TOpenTabFm.OpenTable(SG:TStringGrid);
var i, j, CoordType : integer;
    Sep : Char;
begin
  try
  
   ClearGrid(SG);

   for i:= SpinEdit1.Value-1 to S.count-1 do
   Begin
     if i<0 then
       continue;

     with SG do
         RowCount :=  i + 2 - (SpinEdit1.Value-1);

     if SG.RowCount > 1 then
       SG.FixedRows := 1;
       
     sep:=' ';
     case SepG.ItemIndex of
        0: sep:=' ';
        1: sep:=#$9;
        2: if Edit1.Text<> '' then sep := Edit1.Text[1];
        3: sep:=';';
        4: sep:=',';
     end;

     SG.Cells[0,i+1-(SpinEdit1.Value-1)] := GetCols(s[i], StrToInt(ValueList.Cells[1,1])-1, 1, sep, false);
     SG.Cells[1,i+1-(SpinEdit1.Value-1)] := GetCols(s[i], StrToInt(ValueList.Cells[1,2])-1, 1, sep, true);
     SG.Cells[2,i+1-(SpinEdit1.Value-1)] := GetCols(s[i], StrToInt(ValueList.Cells[1,3])-1, 1, sep, true);
     SG.Cells[3,i+1-(SpinEdit1.Value-1)] := GetCols(s[i], StrToInt(ValueList.Cells[1,4])-1, 1, sep, true);

   end;

   except
   end;


end;

procedure TOpenTabFm.Button1Click(Sender: TObject);
begin
    case isLeftTab of
      true:  OpenTable(LocForm.StringGrid1);
      false: OpenTable(LocForm.StringGrid2);
    end;
    close;
end;

procedure TOpenTabFm.SpinEdit1Change(Sender: TObject);
begin
 RefreshRes;
end;

procedure TOpenTabFm.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
   DrawCellPlus(StringGrid1, ACol, ARow, Rect, State, 1);
end;

end.
