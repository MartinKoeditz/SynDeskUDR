unit SynDeskLevenshtein;

interface

uses Firebird, SysUtils, Math;

function LevenshteinDistance(const s1 : string; s2 : string) : integer;

const
  vcFb = 1000*4;

type
  IncInMessage = record
    v1: record       // Erste Zeichenkette
      Length: Smallint;
      Value: array [0..vcFb - 1] of AnsiChar;
    end;
    v1Null: WordBool;
    v2: record       // Zweite Zeichenkette
      Length: Smallint;
      Value: array [0..vcFb - 1] of AnsiChar;
    end;
    v2Null: WordBool;
  end;

  IncInMessagePtr = ^IncInMessage;

  IncOutMessage = record
    Result: integer;
    resultNull: wordbool;
  end;

  IncOutMessagePtr = ^IncOutMessage;

  IncFunction = class(IExternalFunctionImpl)
    procedure dispose(); override;

    procedure getCharSet(status: iStatus; context: iExternalContext;
      Name: pansichar; nameSize: cardinal); override;

    procedure Execute(status: iStatus; context: iExternalContext;
      inMsg: Pointer; outMsg: Pointer); override;
  end;

  IncFactory = class(IUdrFunctionFactoryImpl)
    procedure dispose(); override;

    procedure setup(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata; inBuilder: iMetadataBuilder;
      outBuilder: iMetadataBuilder); override;

    function newItem(status: iStatus; context: iExternalContext;
      metadata: iRoutineMetadata): IExternalFunction; override;
  end;


implementation

procedure IncFunction.dispose();
begin
  Destroy;
end;

procedure IncFunction.getCharSet(status: iStatus; context: iExternalContext;
  Name: pansichar; nameSize: cardinal);
begin
end;

procedure IncFunction.Execute(status: iStatus; context: iExternalContext;
  inMsg: Pointer; outMsg: Pointer);
var
  xInput: IncInMessagePtr;
  xOutput: IncOutMessagePtr;
  s1: string;
  s2: string;
begin
  xInput := IncInMessagePtr(inMsg);
  xOutput := IncOutMessagePtr(outMsg);

  s1 := xInput^.v1.Value;
  s2 := xInput^.v2.Value;

  xOutput^.resultNull := xInput^.v2Null;
  xOutput^.Result := LevenshteinDistance(s1, s2);
end;


procedure IncFactory.dispose();
begin
  Destroy;
end;

procedure IncFactory.setup(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata; inBuilder: iMetadataBuilder; outBuilder: iMetadataBuilder);
begin
end;

function IncFactory.newItem(status: iStatus; context: iExternalContext;
  metadata: iRoutineMetadata): IExternalFunction;
begin
  Result := IncFunction.Create;
end;

{------------------------------------------------------------------------------
  Name:    LevenshteinDistance
  Params: s1, s2 - UTF8 encoded strings
  Returns: Minimum number of single-character edits.
  Compare 2 UTF8 encoded strings, case sensitive.
  Source: https://wiki.freepascal.org/Levenshtein_distance, 2023/08/31
------------------------------------------------------------------------------}
function LevenshteinDistance(const s1 : string; s2 : string) : integer;
var
  length1, length2, i, j ,
  value1, value2, value3 : integer;
  matrix : array of array of integer;
begin
  length1 := Length( s1 );
  length2 := Length( s2 );
  SetLength (matrix, length1 + 1, length2 + 1);
  for i := 0 to length1 do matrix [i, 0] := i;
  for j := 0 to length2 do matrix [0, j] := j;
  for i := 1 to length1 do
    for j := 1 to length2 do
      begin
        if Copy( s1, i, 1) = Copy( s2, j, 1 )
          then matrix[i,j] := matrix[i-1,j-1]
          else  begin
            value1 := matrix [i-1, j] + 1;
            value2 := matrix [i, j-1] + 1;
            value3 := matrix[i-1, j-1] + 1;
            matrix [i, j] := min( value1, min( value2, value3 ));
          end;
      end;
  result := matrix [length1, length2];
end;


end.
