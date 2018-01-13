player enableFatigue FALSE;
//------------------- client executions
_null = [] execVM "scripts\earplugs.sqf";									// Earplugs from the start

//------------------ BIS groups
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

