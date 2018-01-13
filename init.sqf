call compile preprocessFile "=BTC=_q_revive\config.sqf";

{_x call btc_qr_fnc_unit_init} foreach units group player;

[] spawn {
	// No fatigue
	while {true} do {
		player enableStamina false;
                player forceWalk false;
		uiSleep 6;
	};
};

//---------------------------------------Add cript
//[] execVM "Addons\SlingLoading\fn_advancedSlingLoadingInit.sqf";					
[] execVM "Addons\Towing\fn_advancedTowingInit.sqf";	
//[] execVM "Addons\Rappelling\functions\fn_advancedRappellingInit.sqf";							
[] execVM "Addons\UrbanRappelling\functions\fn_advancedUrbanRappellingInit.sqf";
[] execVM "time.sqf";
_GF = [] execVM "ground_fog.sqf";
[] execVM "AALSSW.sqf";



if(!isMultiplayer) then 
	{

		{
		if(! (isPlayer _x) ) then
			{
				deleteVehicle _x;
			};
		} foreach switchableUnits;

	};

