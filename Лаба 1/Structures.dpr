program Structures;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  StructuresLib in '..\..\..\Загрузки\Laba1\Laba1\StructuresLib.pas';

var
  Adr1,CurAdr: DDList;
  N,k,i,j,z: integer;
begin
  Writeln('Enter N:');
  readln(N);
  Writeln('Enter K:');
  readln(K);
  writeln('--------------------------------------------------------');
  ODCycledListNCreate(Adr1,CurAdr,N);
  CurAdr:=Adr1^.Prev;
  for i:=1 to n-1 do
  begin
    for j:=0 to k-2 do
      CurAdr:=CurAdr^.Next;
    writeln(CurAdr^.Next^.Data);
    CurAdr:=DDListDeleteIn(CurAdr);
  end;
  write('Last: ');
  writeln(CurAdr^.Next^.Data);
  writeln('--------------------------------------------------------');
  for z:=1 to 64 do
  begin
    write(z,':  ');
    ODCycledListNCreate(Adr1,CurAdr,z);
    CurAdr:=Adr1^.Prev;
    for i:=1 to z-1 do
    begin
      for j:=0 to k-2 do
        CurAdr:=CurAdr^.Next;

      //write(CurAdr^.Next^.Data);
      //write(',');
      CurAdr:=DDListDeleteIn(CurAdr);
    end;
    write(CurAdr^.Data);
    writeln;
  end;
  readln;
end.
