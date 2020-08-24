unit Unit1;

interface
function Rus(aStr : String) : String;
function RusRD(const aStr : String) : String;
implementation
uses Windows;

//Подготовка строки к выводу в консоль
function Rus(aStr : String) : String;
begin
  Result := '';
  if Length(aStr) > 0 then
  begin
    SetLength(Result, Length(aStr));
    CharToOem(PChar(aStr), PChar(Result));
  end;
end;

//Обрабтка строки при вводе
function RusRD(const aStr : String) : String;
begin
  Result := '';
  if Length(aStr) > 0 then begin
    SetLength(Result, Length(aStr));
    OemToChar(PChar(aStr), PChar(Result));
  end;
end;

end.
