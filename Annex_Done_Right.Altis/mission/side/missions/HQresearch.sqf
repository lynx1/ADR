/*
  Author:
  Quiksilver

  Last modified:
  24/04/2014
*/

private ["_flatPos","_accepted","_position","_enemiesArray","_fuzzyPos","_x","_briefing","_unitsArray","_object","_dummy","_SMveh","_SMaa","_c4Message","_vehPos"];

_c4Message = ["Жёсткий диск захвачен. C-4 активирован! 5 секунд до детонации.","Научные данные захвачены. Взрывчатка установлена! 5 секунд до взрыва.","Исследовательская работа перехвачена. Заряд установлен! 5 секунд до взрыва."] call BIS_fnc_selectRandom;
#define VEH_TYPE "O_MRAP_02_F","O_Truck_03_covered_F","O_Truck_03_transport_F","O_Heli_Light_02_unarmed_F","O_Truck_02_transport_F","O_Truck_02_covered_F","C_SUV_01_F","C_Van_01_transport_F"

//FIND POSITION FOR OBJECTIVE
  _flatPos = [0,0,0];
  _accepted = false;
  while {!_accepted} do
  {
    _position = [] call BIS_fnc_randomPos;
    _flatPos = _position isFlatEmpty [5,1,0.2,sizeOf "Land_Research_HQ_F",0,false];

    while {(count _flatPos) < 2} do
    {
      _position = [] call BIS_fnc_randomPos;
      _flatPos = _position isFlatEmpty [10,1,0.2,sizeOf "Land_Research_HQ_F",0,false];
    };

    if ((_flatPos distance (getMarkerPos "respawn_west")) > 1700 && (_flatPos distance (getMarkerPos currentAO)) > 500) then
    {
      _accepted = true;
    };
  };

  _vehPos = [_flatPos, 15, 30, 10, 0, 0.5, 0] call BIS_fnc_findSafePos;

//SPAWN OBJECTIVE BUILDING
  sideObj = "Land_Research_HQ_F" createVehicle _flatPos;
  waitUntil {alive sideObj};
  sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), (getPos sideObj select 2)];
  sideObj setVectorUp [0,0,1];

  veh = [VEH_TYPE] call BIS_fnc_selectRandom createVehicle _vehPos;
  veh lock 3;

//TP TABLE, AND LAPTOP ON IT.
  sleep 0.3;
  researchTable setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) + 1)];
  sleep 0.3;
  _dummy = [explosivesDummy1,explosivesDummy2] call BIS_fnc_selectRandom;
  _object = [research1,research2] call BIS_fnc_selectRandom;
  sleep 2;
  { _x enableSimulation true } forEach [researchTable,_object];
  sleep 0.1;
  [researchTable,_object,[0,0,0.8]] call BIS_fnc_relPosObject;

//SPAWN FORCE PROTECTION
  _enemiesArray = [sideObj] call QS_fnc_SMenemyEAST;

//BRIEF
  _fuzzyPos = [((_flatPos select 0) - 300) + (random 600),((_flatPos select 1) - 300) + (random 600),0];

  { _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
  "sideMarker" setMarkerText "Допка: Шпионаж"; publicVariable "sideMarker";
  publicVariable "sideObj";

  _briefing = "<t align='center'><t size='2.2'>Допзадание</t><br/><t size='1.5' color='#00B2EE'>Шпионаж</t><br/>____________________<br/>Силы противника проводят НИР с целью производства новых типов оружия.<br/><br/>Ваша задача — выдвинутся в указанный район, найти и захватить научные данные и затем уничтожить исследовательский центр.</t>";
  GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
  showNotification = ["NewSideMission", "Шпионаж"]; publicVariable "showNotification";
  sideMarkerText = "Шпионаж"; publicVariable "sideMarkerText";

  sideMissionUp = true; publicVariable "sideMissionUp";
  SM_SUCCESS = false; publicVariable "SM_SUCCESS";

//CORE LOOPS
while { sideMissionUp } do
{

  if (!alive sideObj) exitWith
  {

//DE-BRIEFING
    hqSideChat = "Цель уничтожена преждевременно. Задание провалено!"; publicVariable "hqSideChat"; [WEST,"HQ"] sideChat hqSideChat;
    [] spawn QS_fnc_SMhintFAIL;
    { _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker", "sideCircle"]; publicVariable "sideMarker";
    sideMissionUp = false; publicVariable "sideMissionUp";

//DELETE
    { _x setPos [-10000,-10000,0]; } forEach [_object,researchTable,_dummy];
    sleep 120;
    { deleteVehicle _x } forEach [sideObj,veh];
    sleep 0.1;
    deleteVehicle nearestObject [getPos sideObj,"Land_Research_HQ_ruins_F"];
    { [_x] spawn QS_fnc_SMdelete } forEach [_enemiesArray];
  };

  if (SM_SUCCESS) exitWith
  {

    hqSideChat = _c4Message; publicVariable "hqSideChat"; [WEST,"HQ"] sideChat hqSideChat;

//BOOM!
    _dummy setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) + 2)];
    sleep 0.1;
    _object setPos [-10000,-10000,0];       //Hide objective
    sleep 12;                               //Ghetto bomb timer
    "Bo_Mk82" createVehicle getPos _dummy;  //Default "Bo_Mk82"
    _dummy setPos [-10000,-10000,1];        //Hide dummy
    researchTable setPos [-10000,-10000,1]; //Hide research table
    sleep 0.1;

//DE-BRIEFING
    [] call QS_fnc_SMhintSUCCESS;
    { _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker", "sideCircle"]; publicVariable "sideMarker";
    sideMissionUp = false; publicVariable "sideMissionUp";

//DELETE
    sleep 120;
    { deleteVehicle _x } forEach [sideObj,veh];
    deleteVehicle nearestObject [getPos sideObj,"Land_Research_HQ_ruins_F"];
    { [_x] spawn QS_fnc_SMdelete } forEach [_enemiesArray];
  };
};
