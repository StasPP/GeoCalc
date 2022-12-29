unit OutputPlus;



interface

uses Classes, Windows, Graphics, Grids, SysUtils;


procedure DrawCellPlus(StringGrid:TStringGrid; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState; MyStyle:Integer);

implementation

procedure DrawCellPlus(StringGrid:TStringGrid; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState; MyStyle:Integer);
begin
  With StringGrid Do
  Begin
    

    if (ARow > 0) and (MyStyle = 1)
       or (ACol > 0) and (MyStyle = 0) then
    begin
      if Odd(ARow) then  Canvas.Brush.Color := $00FDF8F4
        else Canvas.Brush.Color := clWhite;

      if (gdSelected in State) then
      begin
          Canvas.Brush.Color := $00FBEEE3;//$00FF8000;
          Canvas.Font.Color  := clBlack;
      end
        else
           Canvas.Font.Color := clBlack;
      Canvas.FillRect(Rect);
      Canvas.TextRect(Rect, Rect.Left,Rect.Top, Cells[Acol, Arow]);
    end;

  End;
end;


end.
 