program Graphs;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  GraphLib in 'GraphLib.pas',
  ShowFuncs in 'ShowFuncs.pas';
var
  cnt:integer;
begin
  MakeCMatrix(CMatrix,3);
  writeln('Cost matrix: ');
  ShowMatrix(CMatrix,3);
  writeln;
  writeln('Enter Source and Dest vertexes: ');
  readln(Source);
  readln(Dest);
  writeln;
  FinalMatrix:=Floid(CMatrix,Min,3);
  Printpath(FinalMatrix,'minimal');
  writeln;
  DeikstraMass:=Deikstra(CMatrix,Source,3);
  PrintTheLongest(DeikstraMass,Source,Dest);
  writeln;
  PathMatrix:=doDFS(CMatrix,3,Source,Source,Dest);
  FormCorrectPathList(PathMatrix,CMatrix);
  PrintPathMass(PathMatrix);
  writeln;
  writeln('Floid matrix: ');
  ShowMatrix(FinalMatrix,3);
  writeln;
  writeln('Graph excentricity: ',E,' from vertex: ',CalcE(FinalMatrix,3));
  readln;
end.
