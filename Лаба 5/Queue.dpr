program Queue;

{$APPTYPE CONSOLE}
uses
  SysUtils;

const
  QueueCount=3;
  OperationCount=13;
  Values:array[1..QueueCount,1..3,1..OperationCount] of integer = (
    (
      ( 3,3,4,5,6,4,2,1,5,3,4,0,0 ),
      ( 0,0,0,0,0,0,0,0,0,0,0,0,0 ),
      ( 0,0,0,0,0,0,0,0,0,0,0,0,0 )
    ),
    (
      ( 4,2,5,6,2,1,1,3,3,4,0,0,0 ),
      ( 4,4,5,6,6,2,1,1,3,3,4,4,0 ),
      ( 0,0,0,0,0,0,0,0,0,0,0,0,0 )
    ),
    (
      ( 1,1,4,4,2,2,4,3,3,3,3,5,8 ),
      ( 4,5,1,3,3,3,2,2,4,1,4,6,0 ),
      ( 4,5,1,1,1,3,3,3,2,2,4,1,1 )
    )
  );
  ObjCount:array[1..QueueCount] of integer = (1,2,3);
type
  ListPT=^TTimeList;
  QueueElPT=^TQueueList;

  TTimeList=record
    Next:ListPT;
    Value:Integer;
  end;

  TQueueList=record
    Input:Integer;
    Time:ListPT;
    Next:QueueElPT;
  end;

  TQueue = record
    Head:QueueElPT;
    Tail:QueueElPT;
    Count:Integer;
  end;

  TQueueMas=array[1..QueueCount] of TQueue;
var
  TimeNeed:integer;
  TaktTime,InputTime:integer;
  Objects:TQueueMas;

  sum, stand : integer;
  i, j, k : integer;
  KPD : real;

//����� ������� � ������ �������
function GetFromQueue(var q:TQueue):QueueElPT;
begin
  if q.Head<> nil then
  begin
    result:=q.Head;
    q.Head:=q.Head^.Next;
    q.Count:=q.Count-1;
  end
  else
    result:=nil;
end;

//�������� ������� � ����� �������
procedure AddToQueue(var q:TQueue;var x:QueueElPT);
begin
  x^.Next:=nil;
  if q.Head<> nil then
    q.Tail^.Next:=x
  else
    q.Head:=x;
  q.Tail:=x;
  q.Count:=q.Count+1;
end;

//��������� ����������� �������� � �������� obj � �� �� ������� Queue.
//� standing ������������ ����� �������
procedure DoCPU(var Queue:TQueue ;var obj: QueueElPT; var standing:integer);
var
  temp:ListPT;
  x:QueueElPT;
begin
  // ���� ������� ����� ���������� ��� ������
  if obj^.Time^.Next^.Value <= TaktTime then
  begin
    //��������� ����� ������� ����������
    //(���� ��������� ����-�-����, 0 ������� �� �������)
    standing:=standing + TaktTime - obj^.Time^.Next^.Value;

    //������ ��� �������� �� ������� �� ����������
    temp:=obj^.Time^.Next;
    obj^.Time^.Next:=obj^.Time^.Next^.Next;
    Dispose(temp);
    //���������, ��� ��������� ����
    obj^.Input:=InputTime;
  end
  //������� ����� �� ����������
  else
    Dec(obj^.Time^.Next^.Value, TaktTime);  //������ ��������� ������������ �����

  //�������� ������� �� �������
  x:=GetFromQueue(Queue);
  //���� �� ��� �� �������� - ����� � �������, �� � �����
  if obj^.Time^.Next <> nil then
    AddToQueue(Queue,x)
  else
    Dispose(obj)  //� �������� ���������� - �������� ������
end;

//��������� ����������� ������� ��� ������� � ��
procedure DoNotCPU(var obj: QueueElPT);
begin
  if (obj^.Input <> 0) and (obj^.Input >= TaktTime) then
    obj^.Input:=obj^.Input-TaktTime
  else if (obj^.Input <> 0) then
    obj^.Input:=0;
end;

//��������� � ��������� ����� ����, ����� ������� obj
procedure DoSmth(var obj:QueueElPT);
var
  i,j:integer;
  x:QueueElPT;
begin
  //��� ���� �����������
  for i:=1 to QueueCount do
  begin
    x:=Objects[i].Head;
    //������������� �������
    for j:=1 to  Objects[i].Count do
    begin
      //���� ������ �� obj
      if x <> obj then
        DoNotCPU(x);
      x:=x^.Next;
    end;
  end; //for i
end;

//�������� 1 ����. standing - ���� ������� ���������� �� ���� �����
procedure Takt(var standing:integer);
var
  i,j:integer;
  x:QueueElPT;
  q:^TQueue;
begin
  //���� ������ ����������� � ���������� � ������ ����������
  i:=1;
  x:=nil;
  while i <= QueueCount do
  begin
    //������������� �������
    for j:=1 to Objects[i].Count do
    begin
      x:=Objects[i].Head;

      if x^.Input = 0 then //���� ��������� ��
      begin
        q:=@Objects[i];
        break              //����� ������ ���� �� ����
      end
      else                 //�� �� �����
      begin
        //���������� � ����� �������.
        x:=GetFromQueue(Objects[i]);
        AddToQueue(Objects[i],x);
        x:=nil;
      end;
    end;//for j

    //���� x <> nil �� ����� ��, ��� ��� ����� ������ �������� ��� ������
    if x<>nil then
      break;

    i:=i+1;
  end;//while i
  if x <> nil then
    DoCPU(q^,x,standing) //����� ��������� �� ����������� ������� �������
  else
    standing:=standing+TaktTime; //������ �������� - ���� � ������
  //��������� ��������� � ��������� �����
  DoSmth(x);
end;

//��������� ����� �� ��� ����.
function NeedMore:boolean;
var
  i:integer;
begin
  result:=false;
  for i :=1 to QueueCount do
    if Objects[i].Count<> 0 then
      result:=true;
end;

//��������� ��� �����. ���������� ����� ��������� ������. Standing - ����� �������
function AllTakts(var standing:integer):integer;
begin
  result:=0;
  standing:=0;

  while NeedMore do      //���� �� �������� ��, ��� ����
  begin
    Takt(standing);
    result:=result+1;
  end;
end;

//������������� ������� ���������� ����������. ���������� ������� ������� �� ����������
procedure Initialize(TaktT,InputT:integer);
var
  i,j,k:integer;
  x:QueueElPT;
  t,t1:ListPT;
begin
  TimeNeed:=0;
  //���������� �������� ����������� �������
  TaktTime:=TaktT;
  InputTime:=InputT;

  //��������� �������
  for i:=1 to QueueCount do
  begin
    //������ �������
    Objects[i].Head:=nil;
    Objects[i].Tail:=nil;
    Objects[i].Count:=0;

    //�������� ��������
    for j:=1 to ObjCount[i] do
    begin
      //������ �������
      New(x);
      x^.Next:=nil;
      x^.Input:=0;
      New(x^.Time);
      New(x^.Time^.Next);
      t:=x^.Time^.Next;

      //��������� ��������
      for k:=1 to OperationCount do
      begin
        if Values[i,j,k] <> 0 then
        begin
          TimeNeed:=TimeNeed+Values[i,j,k];
          t^.Value:=Values[i,j,k];
          t1:=t;
          New(t);
          t1^.Next:=t
        end;
      end;//for k
      t1^.Next:=nil;

      AddToQueue(Objects[i],x);
    end;//for j
  end;//for i
end;

begin
  writeln('Takt    |     1    |     2    |     3    |     4    |     5    |     6    |     7    |     8    |     9    |     10   |');
  writeln('--------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+');
  sum:=0;
  for i:=1 to 3 do
    for j:=1 to 3 do
      for k:=1 to 13 do
        sum:=sum+Values[i,j,k];
  for i:=0 to 9 do
  begin
    write('Input ',(i+1):2,'| ');
    for j:=1 to 10 do
    begin
      stand:=0;
      Initialize(j,i+1);
      KPD:=sum/(AllTakts(stand)*j+5);
      write(KPD:4:2, '/',stand+2:3,' | ');
    end;
    writeln;
    writeln('--------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+');
  end;
  readln;
end.

