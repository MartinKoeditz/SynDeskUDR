library SynDeskUDR;

{$DEFINE THREADSAFE}

{$IFDEF FPC}
  {$IFDEF GENERIC}
    {$MODE OBJFPC}{$H+}
  {$ELSE}
    {$MODE DELPHI}{$H+}
  {$ENDIF}
{$ELSE}
{$ENDIF}

uses
  Udr_Init,
  UdrInc in 'SynDeskLevenshtein.pas';

exports firebird_udr_plugin;
begin
  IsMultiThread := true;
end.

