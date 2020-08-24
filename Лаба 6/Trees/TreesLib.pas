unit TreesLib;

interface
uses
  SysUtils,Windows;
type
  TNodeState=(LeftChild,RightChild,RootNode);
  TTreeType=(Sewed,UnSewed);
  PNode=^Tree;
  Tree=record
          Data: integer;
          Left: PNode;
          Right: PNode;
          case TreeType:TTreeType of
            Sewed: (rtag,ltag: boolean);
        end;
var
  NodeState: TNodeState;
  Root: PNode;
  PrevNode,SewRoot,HeadNode: PNode;
  HCon: integer;
procedure DelFromTree(var Node: PNode; DelData:integer);
function AddNode(Data: integer; var CurrRoot:PNode; TreeType: TTreeType): PNode;
Procedure ARB_print(var Node:PNode);
Procedure RAB_print(var Node:PNode);
Procedure ABR_print(var Node:PNode);
procedure SewedARBCreate(var Node:PNode);
procedure PrintTree(TreeRoot: PNode; lev:integer);
procedure SewedARB_print(var Node:PNode; var head: PNode);
procedure EndCycle(var TreeRoot: PNode; var Head: PNode );

implementation

function IsTheRightest(var TreeRoot: PNode; var Head: PNode; var Node: PNode): boolean;
begin
  IsTheRightest:=false;
  if (TreeRoot<>Nil) and ((TreeRoot^.Right=Nil)or (TreeRoot^.rtag=false))  then
    if (TreeRoot=Node) then
     IsTheRightest:=true
  else
    IsTheRightest(TreeRoot^.Right,Head,Node);
end;

function IfFree(var head: PNode): boolean;
begin
  if head=NIL then
    IfFree:=true
  else
    IfFree:=false;
end;

function StartTree(Data: integer): PNode;
var
  Q: PNode;
begin
  New(Q);
  Q^.Data:=Data;
  Q^.Left:=NIL;
  Q^.Right:=NIL;
  Q^.rtag:=true;
  StartTree:=Q;
  writeln('Tree is created');
end;

function StartSewedTree(Data: integer; var Head: PNode): PNode;
var
  Q: PNode;
begin
  New(Q);
  Q^.Data:=Data;
  Q^.Left:=NIL;
  Q^.Right:=NIL;
  Q^.rtag:=false;
  New(Head);
  Head^.Left:=Q;
  Head^.Right:=Head;
  StartSewedTree:=Q;
  writeln('Tree is created');
end;

procedure DelFromTree(var Node: PNode; DelData:integer);
Var Q:PNode;
procedure DelNode(var CurrNode: PNode);
Begin
  If (CurrNode^.right<>nil) and (CurrNode^.rtag<>false) then
    DelNode(CurrNode^.right)
  Else
  Begin
    Q:=CurrNode;
    Node^.data:=CurrNode^.data;
    //if CurrNode^.Left^.rtag=false then
      //CurrNode^.Left^.Right:=nil;
    CurrNode:=CurrNode^.left;
  End;
End;

Begin
  If Node<>nil then
    If (DelData<Node^.data) then
      DelFromTree(Node^.left,DelData)
    Else
      If (Node^.rtag<>false) and (DelData>Node^.data) then
        DelFromTree(Node^.right,DelData)
      Else
      Begin
        Q:=Node;
        If (Node^.right=nil) or (Node^.rtag=false) then
        begin
          Node^.Left^.Right:=nil;
          Node:=Node^.left;
        end
        Else
          If (Node^.left=nil) Then
            Node:=Node^.right
          Else DelNode(node^.left);
        dispose(Q);
      End;

End;

function InsertNode(var node:PNode; Data:integer): PNode;
Begin
  If node=nil then
  Begin
  new(node);
  node^.data:=Data;
  node^.left:=nil;
  node^.right:=nil;
  node^.rtag:=true;
  End
  Else
    If Data<node^.data then
      InsertNode(node^.left,Data)
    Else
    begin
       If Data=node^.data then
          writeln('Such node already exists!')
       else
       begin
          if (node^.rtag=false) then
            node^.right:=nil;
          InsertNode(node^.right,Data);
          node^.rtag:=true;
       end;
    end;
End;

function AddNode(Data: integer; var CurrRoot:PNode; TreeType: TTreeType): PNode;
begin
  if IfFree(CurrRoot) then
  begin
    if TreeType=Sewed then
     CurrRoot:=StartSewedTree(Data,HeadNode)
    else
     CurrRoot:=StartTree(Data);
    AddNode:=CurrRoot;
  end
  else
    AddNode:=InsertNode(CurrRoot,Data);
end;

Procedure RAB_print(var Node:PNode);
Begin
  if Node<> nil then
  Begin
    hCon := GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hCon, 10);
    write(Node^.data,' ');
    hCon := GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hCon, 1);
    RAB_print(Node^.left);
    write(Node^.data,' ');
    RAB_print(Node^.right);
    write(Node^.data,' ');
  End;
End;

Procedure ARB_print(var Node:PNode);
Begin
  if Node<> nil then
  Begin
    write (Node^.data,' ');
    ARB_print(Node^.left);
    hCon := GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hCon, 10);
    write (Node^.data,' ');
    hCon := GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hCon, 1);
    ARB_print(Node^.right);
    write (Node^.data,' ');
  End;
end;

Procedure ABR_print(var Node:PNode);
Begin
  if Node<> nil then
  Begin
    write (Node^.data,' ');
    ABR_print(Node^.left);
    write (Node^.data,' ');
    ABR_print(Node^.right);
    hCon := GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hCon, 10);
    write (Node^.data,' ');
    hCon := GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hCon, 1);
  End;
End;

procedure SewedARBCreate(var Node:PNode);
procedure RightSew(var CurrNode:PNode);
begin
  if PrevNode<> nil then
  begin
    if (PrevNode^.right=nil) then
    begin
      PrevNode^.rtag := false;
      PrevNode^.right := CurrNode;
    end
    else
      ;
  end;
  PrevNode:=CurrNode;
end;
begin
  if (Node<> nil) and ((Node^.Right<>headNode) or (PrevNode=Nil)) then
  begin
    SewedARBCreate(Node^.left);
    RightSew(Node);
    if Node^.rtag=true then
      SewedARBCreate(Node^.right);
  end;
end;


procedure SewedARB_print(var Node:PNode; var head: PNode);
var
  CurrNode: PNode;
begin
  CurrNode:=Node;
  while (CurrNode<>head) and (CurrNode<>nil) do
  begin
    while CurrNode^.left<>nil do
      CurrNode:=CurrNode^.left;
      hCon := GetStdHandle(STD_OUTPUT_HANDLE);
      SetConsoleTextAttribute(hCon, 10);
      write(CurrNode^.data,' ');
      hCon := GetStdHandle(STD_OUTPUT_HANDLE);
      SetConsoleTextAttribute(hCon, 1);
      if CurrNode^.rtag=false then
      begin
        while CurrNode^.rtag = false do
        begin
          CurrNode:=CurrNode^.right;
          if CurrNode=head then
            exit;
          hCon := GetStdHandle(STD_OUTPUT_HANDLE);
          SetConsoleTextAttribute(hCon, 10);
          write(CurrNode^.data,' ');
          hCon := GetStdHandle(STD_OUTPUT_HANDLE);
          SetConsoleTextAttribute(hCon, 1);
        end;
      end;
        CurrNode:=CurrNode^.right;
  end;
end;

procedure PrintTree(TreeRoot: PNode; lev:integer);
var
  i: integer;
begin
  if TreeRoot=Nil then
    exit;
  if TreeRoot^.rtag<>false then
    PrintTree(TreeRoot^.Right,lev+1);
  for i:=1 to lev do
  write('    ');
  writeln(TreeRoot^.Data);
  PrintTree(TreeRoot^.Left,lev+1);
end;

procedure EndCycle(var TreeRoot: PNode; var Head: PNode );
begin
  if (TreeRoot^.Right<>nil) and (TreeRoot^.Right<>Head) then
    EndCycle(TreeRoot^.Right,Head)
  else
  begin
    TreeRoot^.Right:=Head;
    TreeRoot^.rtag:=false;
  end;
end;
end.
