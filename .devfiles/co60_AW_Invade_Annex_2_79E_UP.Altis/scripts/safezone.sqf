/*
	GrenadeStop v0.8 for ArmA 3 Alpha
	
AUTHOR:
	
	Bake (tweaked slightly by Rarek)
	
DESCRIPTION:
	
	Stops players from throwing grenades and firing weapons in safety zones. Does not prevent vehicles firing.
	
CONFIGURATION:

	Edit the #defines below.
	
_______________________________________________________________________*/

#define SAFETY_ZONES	[["respawn_west", 500], ["respawn_pilot", 300]] // Syntax: [["marker1", radius1], ["marker2", radius2], ...]
#define MESSAGE "Бесцельное использование оружия на базe запрещено!"

waitUntil {!isNull player};

player addEventHandler ["Fired", {
	if ({(_this select 0) distance getMarkerPos (_x select 0) < _x select 1} count SAFETY_ZONES > 0) then
	{
		deleteVehicle (_this select 6);
		titleText [MESSAGE, "PLAIN", 3];
	};
}];