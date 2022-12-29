program GenUTC2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes;

var S1, s2: TStringList;
      i, j, shift: integer;
      needn: boolean;
      substr,substr2, curname, curcapt :string;

function GetCols(str, sep: string; ColN, ColCount:integer): string;
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

    if result <> '' then
      for j:= 1 to length(Result)+1 do
        if ((Result[j] = '.') or (Result[j] = ','))and(Result[j]<>sep) then
           Result[j] := DecimalSeparator;
end;

begin
  S1 := TStringList.Create;
  S2 := TStringList.Create;

{  for i := 4 to 30 do
  begin
    S1.Clear;
    if i<10 then substr:='0'
      else substr:= '';

    S1.Add('���:');
    S1.Add('SK42-'+inttostr(i));
    S1.Add('');
    S1.Add('��������:');
    S1.Add('��-42 ���� '+inttostr(i)+' (' + IntToStr( ((i-1)*6) ) + #176+' �� - '+ IntToStr(i*6)+#176+' ��)');
    S1.Add('');
    S1.Add('�����:');
    S1.Add('SK42');
    S1.Add('');
    S1.Add('��� ��������:');
    S1.Add('Gauss');
    S1.Add('');
    S1.Add('���������:');
    S1.Add('��42 �������� ������-�������');
    S1.Add('');
    S1.Add('��������� ��������:');
    S1.Add(inttostr( trunc((i-0.5)*6)) );
    S1.Add('');
    S1.Add('��������� ������:');
    S1.Add('0');
    S1.Add('');
    S1.Add('�������:');
    S1.Add('1');
    S1.Add('');
    S1.Add('�������� �������� �� ������:');
    S1.Add(inttostr(trunc((i+0.5)*1000000)));
    S1.Add('');
    S1.Add('�������� �������� �� �����:');
    S1.Add('0');
    S1.Add('');
    S1.SaveToFile('SK42-'+substr+inttostr(i)+'.txt');
  end;

   for i := 4 to 30 do
  begin
    S1.Clear;
    if i<10 then substr:='0'
      else substr:= '';

    S1.Add('���:');
    S1.Add('SK95-'+inttostr(i));
    S1.Add('');
    S1.Add('��������:');
    S1.Add('��-95 ���� '+inttostr(i)+' (' + IntToStr( ((i-1)*6) ) + #176+' �� - '+ IntToStr(i*6)+#176+' ��)');
    S1.Add('');
    S1.Add('�����:');
    S1.Add('SK95');
    S1.Add('');
    S1.Add('��� ��������:');
    S1.Add('Gauss');
    S1.Add('');
    S1.Add('���������:');
    S1.Add('��95 �������� ������-�������');
    S1.Add('');
    S1.Add('��������� ��������:');
    S1.Add(inttostr( trunc((i-0.5)*6)) );
    S1.Add('');
    S1.Add('��������� ������:');
    S1.Add('0');
    S1.Add('');
    S1.Add('�������:');
    S1.Add('1');
    S1.Add('');
    S1.Add('�������� �������� �� ������:');
    S1.Add(inttostr(trunc((i+0.5)*1000000)));
    S1.Add('');
    S1.Add('�������� �������� �� �����:');
    S1.Add('0');
    S1.Add('');
    S1.SaveToFile('SK95-'+substr+inttostr(i)+'.txt');
  end;

  for i := 1 to 60 do
  begin
    S1.Clear;
    if i<10 then substr:='0'
      else substr:= '';

    S1.Add('���:');
    S1.Add('UTM_WGS-'+inttostr(i)+'N');
    S1.Add('');
    S1.Add('��������:');

    if i<30 then substr2:='��'
      else substr2:= '��';
    j := (i-1)*6 ;
      if j>=180 then
        j:= j-180;
                            
    S1.Add('UTM (WGS-84) ���� '+inttostr(i)+'N (' + IntToStr(j) +#176+ ' '
          +substr2+' - '+ IntToStr(j+6)+#176+' '+substr2+'), �������� ���������');
    S1.Add('');
    S1.Add('�����:');
    S1.Add('WGS84');
    S1.Add('');
    S1.Add('��� ��������:');
    S1.Add('UTM');
    S1.Add('');
    S1.Add('���������:');
    S1.Add('Universal Transverse Mercator');
    S1.Add('');
    S1.Add('��������� ��������:');
    S1.Add(inttostr( trunc((i-0.5)*6)-180) );
    S1.Add('');
    S1.Add('��������� ������:');
    S1.Add('0');
    S1.Add('');
    S1.Add('�������:');
    S1.Add('0.9996');
    S1.Add('');
    S1.Add('�������� �������� �� ������:');
    S1.Add(inttostr(500000));
    S1.Add('');
    S1.Add('�������� �������� �� �����:');
    S1.Add('0');
    S1.Add('');
    S1.SaveToFile('UTM_WGS-'+substr+inttostr(i)+'N.txt');
  end;    }

  S2.LoadFromFile('MSK.txt');

  i:=0;
  j:=0;
  repeat

    if S2[i]='' then
      j:=0;

    if j=1 then
    begin
      Curname := s2[i];

      if s2[i+3]='' then
        needn:= false
          else needn := true;
    end;

    if j=2 then
      CurCapt := s2[i];

    if j>2 then
    Begin

        S1.Clear;
    if i<10 then substr:='0'
      else substr:= '';

    S1.Add('���:');
    S1.Add(Curname+'-'+inttostr(j-2));
    S1.Add('');
    S1.Add('��������:');

    substr:='' ;
    if NeedN then
      substr:=' ���� '+ inttostr(j-2);

    S1.Add(Curcapt+substr);
    S1.Add('');
    S1.Add('�����:');
    if GetCols(s2[i],',',2,1)='9999'
      then
       S1.Add('MSK42')
         else
          S1.Add('SK42');
    S1.Add('');
    S1.Add('��� ��������:');
    S1.Add('Gauss');
    S1.Add('');
    S1.Add('���������:');
    S1.Add('������� ������� ��������� ��������� ��');
    S1.Add('');
    shift := 0;
    if GetCols(s2[i],',',2,1)='9999'
      then
        shift :=9;
    S1.Add('��������� ��������:');
    S1.Add(GetCols(s2[i],',',4+shift,1));
    S1.Add('');
    S1.Add('��������� ������:');
    S1.Add('0');
    S1.Add('');
    S1.Add('�������:');
    S1.Add('1');
    S1.Add('');
    S1.Add('�������� �������� �� ������:');
    S1.Add(GetCols(s2[i],',',7+shift,1));
    S1.Add('');
    S1.Add('�������� �������� �� �����:');
    S1.Add(GetCols(s2[i],',',8+shift,1));
    S1.Add('');
    S1.SaveToFile(Curname+'-'+inttostr(j-2)+'.txt');

 End;

   inc(i);
   inc(j);
  until i>=S2.Count-1;

  S1.Destroy;
  S2.Destroy;
end.
 