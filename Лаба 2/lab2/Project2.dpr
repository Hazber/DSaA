program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  //Типы для описания списка.
 
  //Тип данных - определяет данные, которые будет содержать каждый элемент списка.
  TData = Integer;
  //Тип, описывающий элемент списка.
  TPElem = ^TElem;
  TElem = record
    Data : TData;
    PNext : TPElem;
    PPrev : TPElem;
  end;
  //Тип, описывающий список.
  TList = record
    PFirst : TPElem;
    PLast : TPElem;
  end;

var
  List : TList;
  PElem : TPElem;
  i : Integer;

//Процедуры для работы со списком.
 
//Удаление всего списка из памяти и инициализация.
procedure ListFree(var aList : TList);
var
  PNext, PDel : TPElem;
begin
  if aList.PFirst = nil then Exit;
 
  PNext := aList.PFirst;
  while PNext <> nil do
  begin
    PDel := PNext;
    PNext := PNext^.PNext;
    Dispose(PDel);
  end;
 
  aList.PFirst := nil;
  aList.PLast := nil;
end;
 
//Добавление элемента в конец списка.
procedure AddL(var aList : TList; const aPElem : TPElem);
begin
  if aPElem = nil then Exit;
 
  aPElem^.PNext := nil;
  aPElem^.PPrev := nil;
  if aList.PFirst = nil then
    aList.PFirst := aPElem
  else
  begin
    aList.PLast^.PNext := aPElem;
    aPElem^.PPrev := aList.PLast;
  end;
  aList.PLast := aPElem;
end;

//Вывод списка.
function ListText(const aList : TList) : String;
var
  PElem : TPElem;
  i : Integer;
begin
  Result := '';
  i := 0;
  PElem := aList.PFirst;
  while PElem <> nil do
  begin
    Inc(i);
    if i > 1 then Result := Result + ', ';
    Result := Result + IntToStr(PElem^.Data);
    PElem := PElem^.PNext;
  end;
end;

//Пузырьковая сортировка
procedure SortBubbleAsc(const aList : TList);
var
  P1, P2, P : TPElem;
  Data : TData;
  F : Boolean;
begin
  if aList.PFirst = aList.PLast then Exit;

  P := aList.PLast;
  repeat
    F := False;

    P1 := aList.PFirst;
    P2 := P1^.PNext;
    while P1 <> P do
    begin
      if P1^.Data < P2^.Data then
      begin
        Data := P1^.Data;
        P1^.Data := P2^.Data;
        P2^.Data := Data;
        F := True;
      end;
      P1 := P2;
      P2 := P1^.PNext;
    end;

    P := P^.PPrev;
  until not F;
end;

procedure UdalenThreeSimb (var alist : TList);
var
  P1 : TPElem;
begin
  P1 := aList.PFirst;
  while P1<>nil do
  begin
    if not (P1.Data<1000) then
      write(P1^.data, ' ');
    P1:=P1.PNext;
  end;
end;

begin
  //Инициализация списка.
  List.PFirst := nil;
  List.PLast := nil;
 
  //Создаём несколько элементов и помещаем их в список
  //через процедуру добавления в конец списка.
  for i := 1 to 6 do
  begin
    New(PElem);
    write('Enter your number: ');
    Readln(PElem^.Data);
    AddL(List, PElem);
  end;

  Writeln('Your List: ');
  Writeln(ListText(List));
  //Writeln('From right to left:');
  //printzadom(list);
  SortBubbleAsc(List);
  //Writeln(ListText(List));

  Writeln('Without special number');
  UdalenThreeSimb(List);
  ListFree(List);

  Readln;
  Readln;
end.
