unit SynDeskLevenshtein;

interface

uses Firebird, SysUtils, Math;

const
  vcFb = 32765;

type
  IncInMessage = record
    v1: record       // Erste Zeichenkette
      Length: Word;
      Value: array [0..vcFb - 1] of AnsiChar;
      Null: WordBool;
    end;
    v1Null: WordBool;
    v2: record       // Zweite Zeichenkette
      Length: Word;
      Value: array [0..vcFb - 1] of AnsiChar;
      Null: WordBool;
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

  xOutput^.resultNull := xInput^.v2.Null;
  xOutput^.Result := Length(s1) + Length(s2);   // Länge von s2 ist immer 0
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


end.
