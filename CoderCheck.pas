unit CoderCheck;

interface

uses SysUtils, Classes, Windows;

procedure CheckCharSet(var F:string);

implementation

type
  TEncode = (ENC_UNKNOWN, ENC_CP1251, ENC_CP866, ENC_UTF8, ENC_UTF16LE, ENC_UTF16BE);
  TBOM = (BOM_EMPTY, BOM_UTF8, BOM_UTF16LE, BOM_UTF16BE);


procedure CheckCharSet(var F:string);

 const
    DRuCP1251 = [#$C0..#$FF, #$A8, #$B8];
    DRuCP866 = [#$80..#$AF, #$E0..#$F1];

  function GetBOM(const aStr : AnsiString) : TBOM;
  var
    Len : Integer;
  begin
    Result := BOM_EMPTY;
    Len := Length(aStr);
    if (Len >= 3) and (Copy(aStr, 1, 3) = #$EF#$BB#$BF) then
      Result := BOM_UTF8
    else if Len >= 2 then
      if Copy(aStr, 1, 2) = #$FF#$FE then
        Result := BOM_UTF16LE
      else if Copy(aStr, 1, 2) = #$FE#$FF then
        Result := BOM_UTF16BE;
  end;

  function CntRuCP1251(const aStr : AnsiString) : Integer;
  var  i : Integer;
  begin
    Result := 0;
    for i := 1 to Length(aStr) do
      if aStr[i] in DRuCP1251 then
        Inc(Result);
  end;

  function IsCP1251(const aStr : AnsiString) : Boolean;
  const
    DCP866 = DRuCP866 - DRuCP1251;
  var
   i, Cnt, CntCP866 : Integer;
  begin
    Cnt := 0;
    CntCP866 := 0;
    for i := 1 to Length(aStr) do
     if aStr[i] in DRuCP1251 then
      Inc(Cnt)
    else if aStr[i] in DCP866 then
      Inc(CntCP866);
    Result := (CntCP866 = 0) and (Cnt > 1);
  end;

  function IsCP866(const aStr : AnsiString) : Boolean;
  const
    DCP1251 = DRuCP1251 - DRuCP866;
  var
    i, Cnt, CntCP1251 : Integer;
  begin
    Cnt := 0;
    CntCP1251 := 0;
    for i := 1 to Length(aStr) do
      if aStr[i] in DRuCP866 then
        Inc(Cnt)
      else if aStr[i] in DCP1251 then
        Inc(CntCP1251);
    Result := (CntCP1251 = 0) and (Cnt > 1);
  end;

  function IsUTF8(const aStr : AnsiString) : Boolean;
  begin
    Result := GetBOM(aStr) = BOM_UTF8;
    if not Result then
      Result := CntRuCP1251(Utf8ToAnsi(aStr)) > 1;
  end;

  function IsUTF16LE(const aStr : AnsiString) : Boolean;
  var
    Ws : WideString;
    Len : Integer;
  begin
    Result := GetBOM(aStr) = BOM_UTF16LE;
    if not Result then
    begin
      Len := Length(aStr) div SizeOf(WideChar);
      SetLength(Ws, Len);
      CopyMemory(Pointer(Ws), Pointer(aStr), Len * SizeOf(WideChar));
      //WideString -> AnsiString (UTF-16LE -> ANSI).
      Result := CntRuCP1251(Ws) > 1;
    end;
  end;

  function IsUTF16BE(const aStr : AnsiString) : Boolean;
  var
    Ws : WideString;
    P1, P2 : PAnsiChar;
    i, Len : Integer;
  begin
    Result := GetBOM(aStr) = BOM_UTF16BE;
    if not Result then
    begin
      Len := Length(aStr) div SizeOf(WideChar);
      SetLength(Ws, Len);
      P1 := Pointer(aStr);
      P2 := Pointer(Ws);

      //UTF-16BE -> UTF-16LE
      for i := 1 to Len do
      begin
        P2[0] := P1[1];
        P2[1] := P1[0];
        Inc(P1, 2);
        Inc(P2, 2);
      end;
      //WideString -> AnsiString (UTF-16LE -> ANSI).
      Result := CntRuCP1251(Ws) > 1;
    end;
  end;


  function GetEncode(const aStr : String) : TEncode;
  begin
    Result := ENC_UNKNOWN;
    if IsUTF8(aStr) then
      Result := ENC_UTF8
    else if IsUTF16LE(aStr) then
      Result := ENC_UTF16LE
    else if IsUTF16BE(aStr) then
      Result := ENC_UTF16BE
    //CP1251 - CP866
    else if IsCP1251(aStr) then
      Result := ENC_CP1251
    else if IsCP866(aStr) then
      Result := ENC_CP866;
  end;

  //OEM (DOS, CP866) -> ANSI (Windows, CP1251).
  function StrOemToAnsi(const aStr : AnsiString) : AnsiString;
  var
    Len : Integer;
  begin
    Len := Length(aStr);
    SetLength(Result, Len);
    OemToCharBuffA(PAnsiChar(aStr), PAnsiChar(Result), Len);
  end;

  //UTF-16BE -> UTF-16LE.
  function StrUTF16BEToLE(aWStr : WideString) : WideString;
  var
    P : PAnsiChar;
    ACh : AnsiChar;
    i : Integer;
  begin
    // UTF-16BE -> UTF-16LE.
    P := Pointer(aWStr);
    for i := 1 to Length(aWStr) do
    begin
      ACh := P[0];
      P[0] := P[1];
      P[1] := ACh;
      Inc(P, 2);
    end;
    Result := aWStr;
  end;

 const
  MaxBuffSize = 4000;
  var
  //  Od : TOpenDialog;
    Fs : TFileStream;
    S  : AnsiString;
    Ws : WideString;
    i, BuffSize : Integer;
    SL :TSTringList;
begin
  SL := TSTringList.Create;
  Fs := TFileStream.Create(F, fmOpenRead + fmShareDenyWrite);
  try
    BuffSize := MaxBuffSize;
    if BuffSize > Fs.Size then
      BuffSize := Fs.Size;
    SetLength(S, BuffSize);
    Fs.Read(S[1], BuffSize);
    Fs.Position := 0;

    case GetEncode(S) of
      ENC_UNKNOWN:
      begin
        SetLength(S, Fs.Size);
        Fs.Read(S[1], Fs.Size);
        for i := 1 to Length(S) do
          if S[i] = #0 then
            S[i] := '?';

         SL.Text := S;
      end;
      ENC_CP1251:
      begin
        SL.LoadFromStream(Fs);
      end;
      ENC_CP866:
      begin
        SetLength(S, Fs.Size);
        Fs.Read(S[1], Fs.Size);
        SL.Text := StrOemToAnsi(S);
      end;
      ENC_UTF8:
      begin
        if GetBOM(S) <> BOM_EMPTY then
          Fs.Position := 3;
        SetLength(S, Fs.Size - Fs.Position);
        Fs.Read(S[1], Fs.Size);
        SL.Text := UTF8Decode(S);
      end;
      ENC_UTF16LE:
      begin
        if GetBOM(S) <> BOM_EMPTY then
          Fs.Position := 2;
        SetLength(Ws, (Fs.Size - Fs.Position) div SizeOf(WideChar));
        Fs.Read(Ws[1], Length(Ws) * SizeOf(WideChar));
        SL.Text := Ws;
      end;
      ENC_UTF16BE:
      begin
        if GetBOM(S) <> BOM_EMPTY then
          Fs.Position := 2;
        SetLength(Ws, (Fs.Size - Fs.Position) div SizeOf(WideChar));
        Fs.Read(Ws[1], Length(Ws) * SizeOf(WideChar));
        SL.Text := StrUTF16BEToLE(Ws);
      end;
    else

    end;
  finally
    F := 'Data\Tmp.tx_';
    SL.SaveToFile(F);
    FreeAndNil(Fs);
    SL.Free;
  end;


end;

end.
 