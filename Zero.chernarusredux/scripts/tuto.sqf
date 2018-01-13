_hunger = true;
_rad = true;
_radprotect = true;
_radWarning = true;
_fireplace = true;
_sleep = true;
_tools = true;
_fuel = true;
_tuto = true;
_timer = 90;

_Consumables = [
"rvg_beans",
"rvg_bacon",
"rvg_milk",
"rvg_rice",
"rvg_rustyCan",
"rvg_plasticBottle",
"rvg_spirit",
"rvg_franta",
"rvg_plasticBottle"
];
/*_Combustibles = [
"rvg_money",
"rvg_notepad",
"rvg_docFolder",
"rvg_matches"
];*/

[["ravage", "status"]] call BIS_fnc_advHint;
while {_tuto} do {
	sleep _timer;
	waitUntil {({side _x != side player} count nearestObjects [player, ["Man"], 30]) isEqualTo 0};
	if (_hunger) then {
		private "_qty";
		_qty = {_x in _Consumables} count magazines player;
		if (player getVariable "hunger" < 95 || player getVariable "thirst" < 95 || !(_qty isEqualTo 0)) then {
			[["ravage", "hunger"]] call BIS_fnc_advHint;
			_hunger = false;
			sleep _timer;
		};
	};
	if (_rad) then {
		if ("rvg_Geiger" in magazines player || player getVariable "radiation" > 750) then {
			[["ravage", "rad"]] call BIS_fnc_advHint;
			_rad = false;
			sleep _timer;
		};
	};
	if (_radprotect) then {
		if ("rvg_antiRad" in magazines player || goggles player in antirad_goggles || player getVariable "radiation" > 3000) then {
			[["ravage", "radProtect"]] call BIS_fnc_advHint;
			_radprotect = false;
			sleep _timer;
		};
	};
	if (_radWarning) then {
		if (player getVariable "radiation" > 3001) then {
			[["ravage", "radWarning"]] call BIS_fnc_advHint;
			_radWarning = false;
			sleep _timer;
		};
	};
	if (_fireplace) then {
		private "_qty";
		//_qty = {_x in _Combustibles} count magazines player;
		_qty = {_x isEqualTo "rvg_matches"} count magazines player;
		if !(_qty isEqualTo 0) then {
			[["ravage", "fireplace"]] call BIS_fnc_advHint;
			_fireplace = false;
			sleep _timer;
		};
	};
	if (_sleep) then {
		private "_qty";
		_qty = {_x in ["rvg_sleepingBag_Blue","rvg_foldedTent"]} count magazines player;
		if !(_qty isEqualTo 0) then {
			[["ravage", "sleep"]] call BIS_fnc_advHint;
			_sleep = false;
			sleep _timer;
		};
	};
	if (_tools) then {
		if ("rvg_toolkit" in magazines player) then {
			[["ravage", "tools"]] call BIS_fnc_advHint;
			_tools = false;
			sleep _timer;
		};
	};
	if (_fuel) then {
		private "_qty";
		_qty = {_x in ["rvg_canisterFuel_Empty","rvg_canisterFuel"]} count magazines player;
		if !(_qty isEqualTo 0) then {
			[["ravage", "fuel"]] call BIS_fnc_advHint;
			_fuel = false;
			sleep _timer;
		};
	};
	if (!_hunger && !_rad && !_radprotect && !_fireplace && !_sleep && !_tools && !_fuel && !_radWarning) then {
		_tuto = false;
	};
};