while {true} do {
	//_dayN = player getVariable ["days_survived", 0];
	sleep (3600 + random 3600)*2;
	//from west to east or vice-versa
	_dir = [[90, 270], [270, 90]] call BIS_fnc_selectRandom;
	_pos = [getPosASL player, 3500 max random 5000, _dir select 0] call BIS_fnc_relPos;
	_Grp = createGroup resistance;
	_Grp setVariable ["onDuty", true];
	_pilot1 = _Grp createUnit ["I_helipilot_F", _pos, [], 3, "CAN_COLLIDE"];
	_pilot2 = _Grp createUnit ["I_helipilot_F", _pos, [], 3, "CAN_COLLIDE"];
	_gunner1 = _Grp createUnit ["I_helicrew_F", _pos, [], 3, "CAN_COLLIDE"];
	_gunner2 = _Grp createUnit ["I_helicrew_F", _pos, [], 3, "CAN_COLLIDE"];
	_heli = createVehicle ["B_Heli_Transport_01_camo_F", _pos, [], 0, "FLY"];
	_heli enableSimulation false;
	_pilot1 moveInDriver _heli;
	_gunner1 moveInAny _heli;
	_pilot2 moveInAny _heli;
	_gunner2 moveInAny _heli;
	_Grp addVehicle _heli;
	_heli setDir (_dir select 1);
	[_heli, false] call rvg_fnc_vehInit;
	_heli enableSimulation true;
	[_Grp, [getPosASL player, 25000, _dir select 1] call BIS_fnc_relPos, 5000] call BIS_fnc_taskPatrol;
	{
		[_x, 10000] spawn rvg_fnc_deleteUnit;
	} forEach [_heli, _pilot1, _pilot2, _gunner1, _gunner2];
	//waitUntil {_dayN < player getVariable ["days_survived", 0]};
};