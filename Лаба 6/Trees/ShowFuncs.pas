unit ShowFuncs;

interface
uses
  SysUtils,GraphLib;

procedure ShowMatrix(var CostMatrix: TCMatrix; n:integer);
procedure PrintPath(var Matrix:TCMatrix; str: string);
procedure PrintPathMass(var PathM: TPathMatrix);
procedure PrintTheLongest(DMatrix:TDMass; Source,Dest:integer);
implementation

procedure ShowMatrix(var CostMatrix:TCMatrix; n:integer);
var
  i,j:integer;
begin
  write('     ');
  for j:=1 to n do
    write('  ',j,'  ');
  writeln;
  for i:=1 to n do
  begin
    write('  ',i,'  |');
    for j:=1 to n do
      write(' ',CostMatrix[i,j],' |');
    writeln;
 end;
end;

procedure PrintPath(var Matrix:TCMatrix; str: string);
begin
  writeln('The ',str,' way between ',Source,' and ',Dest,' vertexes: ',Matrix[Source][Dest]);
end;

procedure PrintTheLongest(DMatrix:TDMass; Source,Dest:integer);
begin
  writeln('The maximal way between ',Source,' and ',Dest,' vertexes: ',DMatrix[Dest]);
end;

procedure PrintPathMass(var PathM: TPathMatrix);
var
  i,j:integer;
begin
  writeln('All possible costs of ways between ',Source,' and ',Dest,' vertexes: ');
  for i:=0 to length(PathM)-1 do
  begin
    for j:=1 to length(PathM[i])-1 do
      write(PathM[i][j],'->');
    writeln(': ',PathM[i][0]);
  end;
end;
end.
