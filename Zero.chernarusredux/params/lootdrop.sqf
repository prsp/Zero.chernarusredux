if (isServer) then
{
	_hard = param [0,1,[999]];

	if (_hard == 0) then {};
	if (_hard == 1) then {_null = execVM "scripts\lootCT.sqf"};

};