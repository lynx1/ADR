/*
@filename: init.sqf
Author:
	
	Quiksilver

Last modified:

	12/05/2014
	
Description:

	Things that may run on both server and client.
	Deprecated initialization file, still using until the below is correctly partitioned between server and client.
______________________________________________________*/


call compile preprocessFile "scripts\=BTC=_revive\=BTC=_revive_init.sqf";
call compile preprocessFile "scripts\=BTC=_TK_punishment\=BTC=_tk_init.sqf";
[] execVM "JTS_SQUAD\Functions.sqf";
if (isDedicated) exitWith { "addToScore" addPublicVariableEventHandler { ((_this select 1) select 0) addScore ((_this select 1) select 1); }; }; // Относится к скрипту =BTC=_revive