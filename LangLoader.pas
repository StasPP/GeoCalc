unit LangLoader;

interface

 uses SysUtils, Forms, Classes, StdCtrls, ExtCtrls, Buttons, Menus, ComCtrls,
      GeoFiles, GeoFunctions, Unit8;

 procedure LoadLang(check:boolean);
 procedure SaveLngs;

 var Inf  :array [0..255] of String;
     Lang :String = 'Russian';
     OldLang :String = 'Russian';
     Langs :array [0..2] of String = ('English','Russian','');

implementation

procedure SaveLngs;
var I, J, k: integer;
    S: TStringList;
begin
  S := TStringList.Create;

  for i := 0 to Application.ComponentCount - 1 do
  begin
    S.Add(Application.Components[I].Name);


    if Application.Components[I] is TForm then
    Begin
       S.Add(Tform(Application.Components[I]).Caption);
       S.Add('');
       with Application.Components[I] as TForm Do
       Begin
         for J := 0 to ComponentCount - 1 do
         Begin
            S.Add(Components[J].Name);

            if Components[J] is TLabel then
               S.Add(TLabel(Components[J]).Caption);

            if Components[J] is TButton then
               S.Add(TButton(Components[J]).Caption);

            if Components[J] is TBitBtn then
               S.Add(TBitBtn(Components[J]).Caption);

            if Components[J] is TGroupBox then
               S.Add(TGroupBox(Components[J]).Caption);

            if Components[J] is TCheckBox then
               S.Add(TCheckBox(Components[J]).Caption);

            if Components[J] is TRadioGroup then
            Begin
               S.Add(TRadioGroup(Components[J]).Caption);
               for K := 0 to TRadioGroup(Components[J]).items.Count - 1 do
                 S.Add(TRadioGroup(Components[J]).items[K]);
            End;

            if Components[J] is TEdit then
               S.Add(TEdit(Components[J]).Text);

            if Components[J] is TMenuItem then
               S.Add(TMenuItem(Components[J]).Caption);

            if Components[J] is TSpeedButton then
            Begin
              S.Add(TSpeedButton(Components[J]).Caption);
              S.Add(TSpeedButton(Components[J]).Hint);
            End;

            if Components[J] is TPageControl then
            Begin
               for K := 0 to TPageControl(Components[J]).PageCount - 1 do
                 S.Add(TPageControl(Components[J]).Pages[K].Caption);
            End;
            S.Add('');
         End;
       End;
    End;

    S.Add('//');
  end;
  S.SaveToFile('Data\Languages\Default.txt');
  S.Free;

end;



procedure LoadLang(check:boolean);
var S : TStringList;
    I, J, K, L :Integer;
begin
  S := TStringList.Create;

  if Check then
  Begin
    OldLang := Lang;
    Lang := Langs[1];
    if fileexists('..\Data\Language.config') then
    try
      S.LoadFromFile('..\Data\Language.config');
      Lang := Langs[StrToInt(S[0])];
    except
      Lang := Langs[0];
    end
     else
        Check := false;

  End;

  S.LoadFromFile('Data\Languages\'+Lang+'\GeoMain.txt');

  K:=0;

  while K < S.Count-2 do
  Begin
    inc(K);

    if S[K] = '//' then
    try
      inc(K);
      for I := 0 to Application.ComponentCount - 1  do
         if (Application.Components[I].Name = S[K]) and (Application.Components[I] is TForm) then
            with Application.Components[I] as TForm Do
            Begin
               inc(K);
               Caption := S[K];
               inc(K);
            while (S[K] <> '//')or(K < S.Count-1) do
            BEGIN
               if (s[k]='//') or (s[K+1]='//') then
                  break;
               inc(K);

               for J := 0 to ComponentCount - 1 do
               Begin

                  //if S[k]='' then
                  //  inc(K);

                 if Components[J].Name = S[K] then
                 Begin
                    inc(K);
                    if Components[J] is TLabel then
                      TLabel(Components[J]).Caption := S[K];

                    if Components[J] is TEdit then
                      TLabel(Components[J]).Caption := S[K];

                    if Components[J] is TBitBtn then
                    Begin
                      TBitBtn(Components[J]).Caption := S[K];
                      inc(k);
                      TBitBtn(Components[J]).Hint := S[K];
                    End;

                    if Components[J] is TSpeedButton then
                    Begin
                      TSpeedButton(Components[J]).Caption := S[K];
                      inc(k);
                      TSpeedButton(Components[J]).Hint := S[K];
                    End;

                    if Components[J] is TButton then
                      TButton(Components[J]).Caption := S[K];

                    if Components[J] is TGroupBox then
                      TGroupBox(Components[J]).Caption := S[K];

                    if Components[J] is TCheckBox then
                      TCheckBox(Components[J]).Caption := S[K];

                    if Components[J] is TMenuItem then
                      TMenuItem(Components[J]).Caption  := S[K];

                    if Components[J] is TRadioGroup then
                    Begin
                      TRadioGroup(Components[J]).Caption := S[K];
                      inc(k);
                      L:=0;
                      while (S[k]<>'')
                         and(L<TRadioGroup(Components[J]).ITEMS.Count) do
                      begin
                        if S[k]<>'' then
                        Begin
                           TRadioGroup(Components[J]).Items[L] := S[K];
                           inc(K);
                           inc(L);
                        End
                         else
                         Begin
                           dec(K);
                           break;
                         End
                          
                      end
                    End;

                    if Components[J] is TPageControl then
                    Begin
                      L:=0;
                      while S[k]<>'' do
                      begin
                        if S[k]<>'' then
                          TPageControl(Components[J]).Pages[L].Caption := S[K];
                        inc(K);
                        inc(L);
                      end
                    End;

                    if Components[J] is TComboBox then
                    Begin
                      L:=0;
                      while S[k]<>'' do
                      begin
                        if S[k]<>'' then
                           TCombobox(Components[J]).Items[L]:= S[K];
                        inc(K);
                        inc(L);
                      end;

                     if Check then
                       if Components[J].Name = 'LangBox' then
                         TCombobox(Components[J]).Hide;
                    End;

                    if s[K+1]='' then
                    inc(K);
                 End;
               End;
               End;
            End;
                 

         Except
           S.Add(inttostr(k));
         End;

    End;


  S.LoadFromFile('Data\Languages\'+Lang+'\GeoInfo.txt');
  for I := 0 to 255 do
  Begin
    if I <= S.Count-1 then

    Inf[i]:= S[i]
      else
        Inf[i] := 'Error ['+IntToStr(I)+']';
  End;

  SuccessStr       := inf[42];
  NotFoundCSStr    := inf[43];
  NotFoundICSStr   := inf[44];
  ProcStr          := inf[45];
  ParamNotFoundStr := inf[46];
  ErrConvStr       := inf[47];

  Form8.ComboBox4.Items[0] := inf[64];
  Form8.ComboBox5.Items[0] := inf[64];
  Form8.ComboBox6.Items[0] := inf[64];

 /// S.LoadFromFile('Data\Editor\'+Lang+'\Locs.txt');

  if OldLang<>Lang then
    GeoTranslate(OldLang, Lang, 'Data\Languages\');

  OldLang := Lang;
  S.Free;
end;

end.
