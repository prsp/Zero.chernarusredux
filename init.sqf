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

player enablesimulation false;
0 fadeSound 0;
startTime = date;
cutText ["","BLACK FADED",60];
hintSilent "loading...";
player addEventHandler ["killed", {3 fadeSound 0; 3 fademusic 0; 3 fadeRadio 0}];
execVM "scripts\intro.sqf";
sleep 5;
hintSilent "";
sleep 3;
[
	format ["<img shadow='0.2' size='6' image='%1' />", "rvg_missions\images\rvg_logo.paa"],
	safezoneX+((safeZoneH-(safeZoneW/8*(4/3)))/2), safeZoneY+((safeZoneH-(safeZoneW/5*(4/3)))/2),
	8, 7, 0, 889
] spawn bis_fnc_dynamicText;
sleep 7;
[   
	"<t  size = '0.5'>Arma3 Mod by Haleks, The DAYS AFTER ZERO Mission By XFiRE ARMY</t>",
	safezoneX+((safeZoneH-(safeZoneW/8*(4/3)))/2), safeZoneY+((safeZoneH-(safeZoneW/100*(4/3)))/2),
	4, 4, 0, 890
] spawn bis_fnc_dynamicText;

15 fadeSound 1;
sleep 7;
cutText ["", "BLACK IN", 20];
_radio=createTrigger["EmptyDetector",[0,0]];
_radio setTriggerActivation["Alpha","PRESENT",true];
_radio setTriggerStatements["this","0=[] execVM 'ravage\code\scripts\system\options.sqf'",""];
1 setRadioMsg "Options";

player enablesimulation true;

sleep 10;
_txt = "DAY " + str ceil (startTime call rvg_fnc_returnDays);
[_txt, safezoneX +  safezoneW - 0.65, safeZoneY + safezoneH - 0.2, 10, 0, 0, 888] spawn bis_fnc_dynamicText;
while {alive player} do {
	_d = ceil (startTime call rvg_fnc_returnDays);
	waitUntil {if (!alive player) exitWith {true}; sleep 1.5; ceil (startTime call rvg_fnc_returnDays) > _d || visibleMap};
	if (!alive player) exitWith {true};
	_txt = "DAY " + str ceil (startTime call rvg_fnc_returnDays);
	[_txt, safezoneX +  safezoneW - 0.65, safeZoneY + safezoneH - 0.2, 10, 0, 0, 888] spawn bis_fnc_dynamicText;
};
cutText ["", "BLACK OUT", 20];
sleep 3;
_n = format ["<t  size = '1'>%1</t>", ceil (startTime call rvg_fnc_returnDays) - 1];
_d = "<t  size = '1'> DAYS.</t>";
if ((ceil (startTime call rvg_fnc_returnDays) - 1) < 2) then {_d = "<t  size = '1'> DAY.</t>"};
_txt = "<t  size = '1'>YOU SURVIVED </t>" + _n + _d;
[   
	_txt,
	safezoneX+((safeZoneH-(safeZoneW/8*(4/3)))/2), safeZoneY+((safeZoneH-(safeZoneW/100*(4/3)))/2),
	60, 5, 0, 890
] spawn bis_fnc_dynamicText;