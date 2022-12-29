unit TabFunctions;

interface

uses SysUtils;

  function GetSep(str: string): string;

  function GetCols(str: string; ColN, ColCount:integer;
                    Spc:byte; ReplaceSeps: boolean): string; overload;
  function GetCols(str: string; ColN, ColCount:integer;
                    Sep:char; ReplaceSeps: boolean): string; overload;

  function GetColN(str, sep: string; n: integer): integer;          overload;
  function GetColN(str: string; sep: integer; n: integer): integer; overload;

  function GetColCount(str, sep: string): integer;          overload;
  function GetColCount(str: string; sep: integer): integer; overload;

  function ReplaceDecimals(S :String):string;  overload;
  function ReplaceDecimals(S :String; sep :char):string;  overload;

  const TabChar = #$9;

implementation

function GetSep(str: string): string;
  const
    n = 6;
    seps: array [1..n] of string = (':','/','\','-','.',',');
  var i:integer;
begin
     Result:='';
       for i:=1 to n do
       if Pos(seps[i],str)>1 then
       begin
         Result:=seps[i];
         break;
       end;
end;

function GetColN(str, sep: string; n: integer): integer;  overload;
  var j,stl,b :integer;
  begin

    Result:=0;
    stl:=0;
    b:=1;

    for j:=1 to n do
     if (copy(Str,j,1)=sep) and (copy(Str,j-1,1)<>sep) then
     begin
       inc(stl);
       b:=j+1;
     end;

    Result:=stl;
end;

function GetColN(str: string; sep: integer; n: integer): integer;   overload;
  var j,stl,b :integer;
      sepS: char;
  begin

   Case Sep of
     0: sepS:= ' ';
     1: sepS:= TabChar;
     2: sepS:= '/';// LoadRData.Spacer.Text[1];
     3: sepS:= ';';
     4: sepS:= ',';
   end;

    Result:=0;
    stl:=0;
    b:=1;

    for j:=1 to n do
     if (copy(Str,j,1)=sepS) and (copy(Str,j-1,1)<>sepS) then
     begin
       inc(stl);
       b:=j+1;
     end;

    Result:=stl;
end;

function GetColCount(str, sep: string): integer;          overload;
begin
  Result := GetColN(str, sep, length(str));
end;

function GetColCount(str: string; sep: integer): integer; overload;
begin
  Result := GetColN(str, sep, length(str));
end;

procedure PrepareString(var str:string; sep: string);
var I: integer;
begin
   if (Sep = TabChar) or (Sep = ' ') then
      exit;

   for I := Length(Str)  DownTo 2 Do
     if (Str[I-1] = Sep) and (Str[I] = Sep) then
        Insert(' ', Str, I);
end;

function GetCols(str: string; ColN, ColCount:integer; Spc:byte;
           ReplaceSeps: boolean): string;
var j,stl,b :integer;
    sep :String;
begin
   result:='';
   stl:=0;
   b:=1;
   sep:=' ';

   Case Spc of
     0: sep:=' ';
     1: sep:=TabChar;
     2: sep:='/';// LoadRData.Spacer.Text[1];
     3: sep:=';';
     4: sep:=',';
   end;

   PrepareString(str, sep);

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

  if ReplaceSeps then
  if Sep<>DecimalSeparator then
     Result := ReplaceDecimals(Result);
end;

function GetCols(str: string; ColN, ColCount:integer; Sep:char;
            ReplaceSeps: boolean): string;
var j,stl,b, i :integer;
begin
   result:='';
   stl:=0;
   b:=1;

   PrepareString(str, sep);

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

  if ReplaceSeps then
  if Sep<>DecimalSeparator then
     Result := ReplaceDecimals(Result);

  for I := length(Result) DownTo 1 Do
     if Result[I] <> sep then
        break;

  Result := Copy(Result, 1, I+1);

  for I := 1 To length(Result)-1 Do
     if Result[I] <> sep then
        break;

  Result := Copy(Result, I, Length(Result) - I+1);
end;


function ReplaceDecimals(S:String):string;
var j: integer;
begin
  Result :=  S;
  if result <> '' then
    for j := 1 to length(Result)+1 do
        if ((result[j] = '.') or (result[j] = ',')) then
            result[j] := DecimalSeparator;
end;

function ReplaceDecimals(S :String; sep :char):string;
var j: integer;
begin
  Result :=  S;
  if result <> '' then
    for j := 1 to length(Result)+1 do
        if ((result[j] = '.') or (result[j] = ',')) then
            result[j] := Sep;
end;


{function CopToStr ( var cc ): String ;      // ����������
var c : Array [0..1000] of char absolute cc ;
    i : Integer ;
    s : string ;
begin
       i := 0;
       s := '' ;
       while c[i] <> #0 do
          begin
             s := s + c[i];
             i := i +1;
          end ;
       CopToStr := s;
end;
                                                        
procedure StrLong ( Data : int64; var str : String );   //����������
var s, s1 : string ;
       fl : boolean;
begin
    s := '';
    fl := FALSE ;
    repeat
      system.Str ( Data mod 1000, s1 );
      while Length ( s1 ) <3 do s1 := '0'+s1;
      IF FL THEN
            s := s1 + '.'+s
        ELSE s := s1 ;
      Data := Data div 1000;
      FL := TRUE ;
    until Data <1000;
      system.str ( data, s1 );
      while Length ( s1 ) <3 do s1 := '0'+s1;
      s := s1 + '.'+s;
     str := s ;
 end;
}

function HexToInt(Value: String): LongInt;
var
  L : Longint;
  B : Byte;
begin
  Result := 0;
  if Length(Value) <> 0 then
  begin
    L := 1;
    B := Length(Value) + 1;
    repeat
      dec(B);
      if Value[B] <= '9' then
        Result := Result + StrToInt(Value[B]) * L
      else
        Result := Result + (Ord(Value[B]) - 65) * L;
      L := L * 16;
    until B = 1;
  end;
end;
end.
