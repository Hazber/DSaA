program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

type
  StekElPT=^TStek;

  TStek=record
    Elem:Char;
    Next:StekElPT;
  end;

//Подготовка строки к выводу в консоль
function RusWR(aStr : String) : String;
begin
  Result := '';
  if Length(aStr) > 0 then
  begin
    SetLength(Result, Length(aStr));
    CharToOem(PChar(aStr), PChar(Result));
  end;
end;

//Добавление к стеку st элемента value
Procedure AddSteck (var st:StekElPT;value:Char);
var
  x :StekElPT;
begin
  new(x);          //Добавляемый элемент
  x^.Elem:=value;
  x^.next:=st;     //Стек строим так, что next ссылатся на то, что положили ранше
  st:=x;
end;

//Забрать из стека верхний элемент
function GetStek(var st:StekElPT):Char;
begin
  if st<> nil then
  begin
    GEtStek:=st^.Elem;
    st := st^.next;     //Убираем элемент из стека
  end
  else
    GetStek:=#0;        //Для пустого стека возвращаем символ #0
end;

//Получить стековый пиоритет символа с
function StekPriority (c:Char):Integer;
begin
  case c of
    '+','-' : Result := 2;
    '*','/' : Result := 4;
    '^' : Result := 5;
    'a'..'z','A'..'Z' : Result := 8;
    '(' : Result := 0;
  else
      Result := 10;     //Для неизвестного символа возвращаем 10
  end;
end;

//Получить отнсительный пиоритет символа с
function InpPriority (c:Char):Integer;
begin
  case c of
    '+','-' : Result := 1;
    '*','/' : Result := 3;
    '^' : Result := 6;
    'a'..'z','A'..'Z' : Result := 7;
    '(' : Result := 9;
    ')' : Result := 0;
  else
    Result := 10;       //Для неизвестного символа возвращаем 10
  end;
end;

//Возвращает ранг символа в польской записи
function CharRang(c:Char):integer;
begin
  if c in ['a'..'z','A'..'Z'] then
    Result:=1                          //Для операнда ранг 1
  else
    Result:=-1;                        //Для оператора -1
end;

var
  st:StekElPT;
  input,output:string;
  Rang,i:Integer;
  t:Char;
begin
  st:=nil;     //Сделали стек пустым
  Rang:=0;     //Обнуляем ранг
  output:='';  //И входную строку

  Write(RusWR('Инфиксная форма: '));
  Readln(input);

  i:=1;
  while i<=Length(input) do //i Может измениться не после каждой итерации (Не for)
    //Стек пуст или верхний элемнт стека имеет менщий приоритет
    if  (st=nil) or (InpPriority(Input[i]) > StekPriority(st^.Elem)) then
    begin
      if Input[i] <> ')' then  // ( в стек ложить не надо
        AddSteck(st,input[i]); //Ложим входной символ в стек
      i:=i+1;                //След. символ
    end
    //Стек не пуст и приоритет входного символа меньше
    else
    begin
      t:=GetStek(st);             //Забираем из стека верний символ
      if t <> '(' then //( Добавлять в езултат не надо
      begin
        output:=output+t;           //Дописываем к выходной строке
        Rang := Rang + CharRang(t); //Изменяем ранг выражения
      end;
      //К след символу входной строи не переходим
    end;

  //Дописываем всё что осталось в стеке
  while not (st = nil) do
  begin
    t:=GetStek(st);      //Забираем из стека верний символ
    if t <> '(' then     //( Добавлять в резултат не надо
      output:=output+t;  //Дописываем к выходной строке
  end;

  Write(RusWR('Постфиксная форма: '));
  Writeln(output);
  Write(RusWR('Ранг выражения: '));
  Writeln(Rang);
  Readln;
end.
