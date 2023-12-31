unit Udr_Init;

interface

uses Firebird;

function firebird_udr_plugin(status: iStatus; theirUnloadFlagLocal: BooleanPtr; udrPlugin: iUdrPlugin): BooleanPtr; cdecl;

implementation
uses UdrInc;
var
   myUnloadFlag   : Boolean;
   theirUnloadFlag: BooleanPtr;


function firebird_udr_plugin(status: iStatus; theirUnloadFlagLocal: BooleanPtr; udrPlugin: iUdrPlugin): BooleanPtr; cdecl;
begin
   udrPlugin.registerFunction(status, 'syndesk_levenshtein', IncFactory.create());
   theirUnloadFlag := theirUnloadFlagLocal;
   Result := @myUnloadFlag;
end;

initialization
   myUnloadFlag := false;
finalization
   if ((theirUnloadFlag <> nil) and not myUnloadFlag) then
      theirUnloadFlag^ := true;
end.
