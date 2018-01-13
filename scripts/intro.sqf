0 setRain random 0.7;
0 setFog 0.3;
skiptime random 3;
sleep 1;
execVM "scripts\tuto.sqf";
if (!isNil "_soundSource") then {
	WaitUntil {player distance _soundSource > 1000};
	deleteVehicle _soundSource;
};