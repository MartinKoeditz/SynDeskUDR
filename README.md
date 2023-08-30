# SynDeskUDR
Implementation of Levenshtein as Firebird UDR


1. Copy the SynDeskUDR.dll to the Firebird /plugins/udr folder.

2. Register the UDR in the database:
create function sd_lev (v1 varchar(100), v2 varchar(100) ) 
returns integer
external name 'SynDeskUDR!syndesk_levenshtein'
engine udr;

3. Test it
select sd_lev('tast', 'test') from rdb$database; 
