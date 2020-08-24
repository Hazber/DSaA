program Trees;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  TreesLib in 'TreesLib.pas',
  DopFuncs in 'DopFuncs.pas';

var
  i,choice,hCon: integer;
  f: boolean=true;
begin
  hCon := GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(hCon, 1);
  Form_2_Trees(Root,SewRoot);
  while f do
  begin
    writeln('Choose the tree operation: 1-add new node; 2-Search in tree; 3-Sew a tree; 4-Delete node');
    readln(choice);
    case choice of
    1:
     GlobalAddNode;
    2:
      GlobalSearch;
    3:
      GlobalPrintSewed;
    4:
      GlobalDelete;
    end;
  end;
end.
