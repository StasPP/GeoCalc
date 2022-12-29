program rrnn;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

procedure AddFiles(Dir:string; var FileList:TStringList);
var
   SearchRec : TSearchrec; //Запись для поиска
begin
    if FindFirst(Dir + '*.*', faAnyFile, SearchRec) = 0 then
    begin
      if (SearchRec.Name<> '')
        and(SearchRec.Name <> '.')
        and(SearchRec.Name <> '..')
        and not ((SearchRec.Attr and faDirectory) = faDirectory) then
          FileList.Add(SearchRec.Name);
      while FindNext(SearchRec) = 0 do
        if (SearchRec.Name <> '')
          and(SearchRec.Name <> '.')
          and(SearchRec.Name <> '..')
          and not ((SearchRec.Attr and faDirectory) = faDirectory)  then
             FileList.Add(SearchRec.Name);
      FindClose(Searchrec);
    end;
end;


var F, S :TStringList;
    i, j, p :integer;
    Str : string;
begin
   F := TStringList.Create;
   S := TStringList.Create;

   AddFiles('',F);

   For I := 0 To F.Count-1 do
   Begin
     S.LoadFromFile(F[i]);
     for J := 0 to S.Count-1 do
     begin
       Str := S[j];
       p := Pos('район ', Str);

       If P>1 Then
       Begin
         P:= P+7;
         Insert(',',Str,P);
         S[j] := Str;
         writeln(S[j]);
         S.SaveToFile(F[i]);
         break;
       End;

     end;
   End;

   readln;
   F.Free;
   S.Free;
  { TODO -oUser -cConsole Main : Insert code here }
end.
