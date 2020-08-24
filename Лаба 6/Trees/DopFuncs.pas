unit DopFuncs;

interface
  uses SysUtils,TreesLib;
procedure GlobalAddNode;
procedure GlobalSearch;
procedure GlobalPrintSewed;
procedure GlobalDelete;
procedure Form_2_Trees(var Root1:PNode; var Root2: PNode);

implementation
var
  choice,Node_Data: integer;
procedure GlobalAddNode;
begin
  writeln('Choose the way of adding:1-to the sewed tree; 2-to the unsewed tree');
  readln(choice);
  readln(Node_Data);
  case choice of
  2:
  begin
    AddNode(Node_Data,Root,UnSewed);
    PrintTree(Root,0);
    writeln('Node is added');
  end;
  1:
    begin
      AddNode(Node_Data,SewRoot,Sewed);
      PrintTree(SewRoot,0);
      PrevNode:=Nil;
      EndCycle(SewRoot,HeadNode);
      SewedARBCreate(SewRoot);
      writeln;
      writeln('Node is added');
    end;
  else
    writeln('Command is not correct');
  end;
end;

procedure GlobalSearch;
begin
  writeln('Choose the way of search:1-RAB; 2-ARB; 3-ABR');
  readln(choice);
  case choice of
  1:
    RAB_print(Root);
  2:
    ARB_print(Root);
  3:
    ABR_print(Root);
  end;
  writeln;
end;

procedure GlobalPrintSewed;
begin
  SewedARB_print(SewRoot,HeadNode);
  writeln;
end;

procedure Form_2_Trees(var Root1:PNode; var Root2: PNode);
var
  F1,F2:TextFile;
  Dat:integer;
begin
  AssignFile(F1,'UnSewedTreeData.txt');
  AssignFile(F2,'SewedTreeData.txt');
  Reset(F1);
  Reset(F2);
  while not eof(F1) do
  begin
    readln(F1,Dat);
    AddNode(Dat,Root,UnSewed);
  end;
  PrintTree(Root,0);
  while not eof(F2) do
  begin
      readln(F2,Dat);
      AddNode(Dat,SewRoot,Sewed);
      PrevNode:=Nil;
      EndCycle(SewRoot,HeadNode);
      SewedARBCreate(SewRoot);
  end;
  PrintTree(SewRoot,0);
end;

procedure GlobalDelete;
var
  Del:integer;
begin
  writeln('Choose the tree to delete:1-sewed; 2-unsewed');
  readln(choice);
  case choice of
  1:
  begin
    readln(Del);
    DelFromTree(SewRoot,Del);
    PrevNode:=Nil;
    EndCycle(SewRoot,HeadNode);
    SewedARBCreate(SewRoot);
    PrintTree(SewRoot,0);
  end;
  2:
  begin
    readln(Del);
    DelFromTree(Root,Del);
    PrintTree(Root,0);
  end;
  end;
end;
end.
