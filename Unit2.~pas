unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ValEdit, ComCtrls, Spin, Menus;

type
  TForm2 = class(TForm)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    ValueList: TValueListEditor;
    StringGrid1: TStringGrid;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ComboBox1: TComboBox;
    RadioGroup2: TRadioGroup;
    ComboBox2: TComboBox;
    ListBox4: TListBox;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure RefreshRes;
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ValueListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox4Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ListBox4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  var S: TStringList;
    oldidx, idx: Longint;
    
implementation

uses MainForm, GeoClasses, GeoFunctions, Unit6;
{$R *.dfm}

function GetCols(str, sep: string; ColN, ColCount:integer; ChangeSep:Boolean): string;
  var j,stl,b :integer;
  begin

    Result:='';
    stl:=0;
    b:=1;

    for j:=1 to length(Str)+1 do
    Begin

      if ((copy(Str,j,1)=sep)or(j=length(Str)+1))and(copy(Str,j-1,1)<>sep) then
      begin

       if (stl>=ColN) and (Stl<ColN+ColCount) then
       Begin
        if result='' then
          Result:=(Copy(Str,b,j-b))
            else
              Result:=Result+' '+(Copy(Str,b,j-b));
       End;

       inc(stl);
       b:=j+1;

       if stl>ColN+ColCount then
          break;
      end;

    End;

    if ChangeSep then
    if result <> '' then
      for j:= 1 to length(Result)+1 do
        if ((Result[j] = '.') or (Result[j] = ','))and(Result[j]<>sep) then
           Result[j] := DecimalSeparator;
end;


procedure TForm2.Button2Click(Sender: TObject);
begin
 Form1.CanLoad := false;
 close;
end;

procedure TForm2.RadioGroup1Click(Sender: TObject);
begin
  Edit1.Enabled := RadioGroup1.ItemIndex = 2;
  RefreshRes;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
 Form1.CanLoad := true;
 close;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
var i, j : integer;
begin
  if ComboBox1.ItemIndex>=0 then
  Begin
     // Memo1.clear;
    //ListBox1.Clear;

    i:= FindDatumByCaption(ComboBox1.Items[ComboBox1.ItemIndex]);

    RadioGroup2.ItemIndex := 0;
    RadioGroup2.Buttons[2].Enabled := false;
    RadioGroup2.Buttons[3].Enabled := false;
    RadioGroup2.Buttons[4].Enabled := false;
    for j:=0 to length(DatumList[i].Projections)-1 Do
    begin
      if DatumList[i].Projections[j]='Gauss' then
         RadioGroup2.Buttons[2].Enabled := true;
      if DatumList[i].Projections[j]='UTM' then
      begin
         RadioGroup2.Buttons[3].Enabled := true;
         RadioGroup2.Buttons[4].Enabled := true;
      end;
    end;

  End;

end;

procedure TForm2.RadioGroup2Click(Sender: TObject);
var i:integer;
begin
 { case RadioGroup2.ItemIndex of
    3,4: begin
      ValueList.Keys[1] := 'Имя';
      ValueList.Keys[2] := 'Запад/Восток, м';
      ValueList.Keys[3] := 'Север/Юг, м';
      ValueList.Keys[4] := 'Высота над эл., м';
    end;

    2: begin
      ValueList.Keys[1] := 'Имя';
      ValueList.Keys[2] := 'X, м';
      ValueList.Keys[3] := 'Y, м';
      ValueList.Keys[4] := 'Высота над РЭ, м';
    end;

    1: begin
      ValueList.Keys[1] := 'Имя';
      ValueList.Keys[2] := 'X, м';
      ValueList.Keys[3] := 'Y, м' ;
      ValueList.Keys[4] := 'Z, м' ;
    end;

    0: begin
      ValueList.Keys[1] := 'Имя';
      ValueList.Keys[2] := 'Широта B, '+#176;
      ValueList.Keys[3] := 'Долгота L, '+#176;
      ValueList.Keys[4] := 'Высота над эл., м';
    end;
  end; }
  Form1.RenameTabs(Form2.StringGrid1,Form2.RadioGroup2.ItemIndex);

  for I := 1 to 4 do
    ValueList.Keys[I] := Form2.StringGrid1.Cells[i-1,0];

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 S :=TStringList.Create;
 oldidx := -1;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  S.Destroy;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  S.LoadFromFile(Form1.OpenFileName);
  RefreshRes;
end;

procedure TForm2.RefreshRes;
var i, j, CoordType : integer;
    Sep : String;
begin
   Form1.ClearGrid(Form2.StringGrid1);

   if PageControl1.ActivePageIndex=0 then

   Form1.RenameTabs(Form2.StringGrid1,Form2.RadioGroup2.ItemIndex)
     else
     Begin
        i := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
        CoordType := CoordinateSystemList[i].ProjectionType;
        Form1.RenameTabs(Form2.StringGrid1,CoordType);
     End;
        
   try

   for i:= SpinEdit1.Value-1 to S.count-1 do
   Begin
     if i<0 then
       continue;
       
     if i > 3 + (SpinEdit1.Value-1) then exit;

     with StringGrid1 do
      // if i >= 4 - (SpinEdit1.Value-1) + RowCount-2 then
         RowCount := 5; //i + 2 - (SpinEdit1.Value-1);

     if StringGrid1.RowCount > 1 then
       StringGrid1.FixedRows := 1;

     case RadioGroup1.ItemIndex of
        0: sep:=' ';
        1: sep:=#$9;
        2: if Form2.Edit1.Text<> '' then sep:=Form2.Edit1.Text[1];
        3: sep:=';';
        4: sep:=',';
     end;

     StringGrid1.Cells[0,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,1])-1,1,false);
     StringGrid1.Cells[1,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,2])-1,1,true);
     StringGrid1.Cells[2,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,3])-1,1,true);
     StringGrid1.Cells[3,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,4])-1,1,true);

   end;

   except
   end;

  
end;

procedure TForm2.ValueListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  RefreshRes;
end;

procedure TForm2.ListBox4Click(Sender: TObject);
var i, CoordType : integer;
begin
   if ListBox4.ItemIndex <= -1 then
    exit;

  i := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
   CoordType := CoordinateSystemList[i].ProjectionType;

   { case CoordType of
    3,4: begin
      ValueList.Keys[1] := 'Имя';
      ValueList.Keys[2] := 'Запад/Восток, м';
      ValueList.Keys[3] := 'Север/Юг, м';
      ValueList.Keys[4] := 'Высота над эл., м';
    end;

    2: begin
      ValueList.Keys[1] := 'Имя';
      ValueList.Keys[2] := 'X, м';
      ValueList.Keys[3] := 'Y, м';
      ValueList.Keys[4] := 'Высота над РЭ, м';
    end;

    1: begin
      ValueList.Keys[1] := 'Имя';
      ValueList.Keys[2] := 'X, м';
      ValueList.Keys[3] := 'Y, м' ;
      ValueList.Keys[4] := 'Z, м' ;
    end;

    0: begin
      ValueList.Keys[1] := 'Имя';
      ValueList.Keys[2] := 'Широта B, '+#176;
      ValueList.Keys[3] := 'Долгота L, '+#176;
      ValueList.Keys[4] := 'Высота над эл., м';
    end;
  end;   }
  Form1.RenameTabs(Form2.StringGrid1,CoordType);

  for I := 1 to 4 do
    ValueList.Keys[I] := Form2.StringGrid1.Cells[i-1,0];
end;

procedure TForm2.ComboBox2Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex<>-1 then
    Form1.findCat(Form2.ComboBox2.Items[Form2.ComboBox2.ItemIndex],Form2.ListBox4);
  //Form2.ListBox4.Sorted :=true;
  Form2.ListBox4.ItemIndex :=0;
  Form2.ListBox4.OnClick(nil);
end;

procedure TForm2.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: begin
         ComboBox1.OnChange(nil);
         RadioGroup2.OnClick(nil);
       end;
    1: ListBox4.OnClick(nil);
  end;   
end;

procedure TForm2.ListBox4MouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TForm2.N1Click(Sender: TObject);
begin
 Form6.Aim := 3;
 Form6.ShowModal;
end;

end.
