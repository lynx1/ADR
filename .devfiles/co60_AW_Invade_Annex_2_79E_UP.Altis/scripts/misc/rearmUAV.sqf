private ["_veh"];
_veh = _this select 0;

if (_veh isKindOf "ParachuteBase" || !alive _veh) exitWith {};

if (!(_veh isKindOf "B_UAV_02_CAS_F")) exitWith { 
	_veh vehicleChat "This pad is for UAV service only, soldier!"; 
};

_veh vehicleChat "Обслуживание займет 30 секунд.";

_veh setFuel 0;

//---------- RE-ARMING

_veh vehicleChat "Перезарядка ...";

sleep 10;

_veh setVehicleAmmo 1;
_veh vehicleChat "Заряжен (100%).";

//---------- REPAIRING

sleep 2;

_veh vehicleChat "Ремонт ...";

sleep 10;

_veh setDamage 0;
_veh vehicleChat "Отремонтирован (100%).";

//---------- REFUELING

sleep 2;

_veh vehicleChat "Заправка ...";

sleep 10;

_veh setFuel 1;
_veh vehicleChat "Заправлен (100%).";

//---------- FINISHED

sleep 2;

_veh vehicleChat "Обслуживание завершено. Приятного полета!";