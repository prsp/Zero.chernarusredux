/*
Author: Sarogahtyp

Description:
Spawns weapons, items and bags in buildings near to alive players inside a trigger.
Deletes stuff if players are not close enough anymore.
The script doesnt care about any trigger preferences except the trigger area.
Main while loop runs every 8-12 seconds.
Soft delayed item spawning to prevent performance impact.

How to adjust/use the script: 
_trigger_array   -> contains the names of triggers in which area loot should spawn.

_spawn_chance  ->  The chance to spawn lo																				ot on a specific house position. If the same house is the closest building to 

_item_chance -> chance to spawn an item instead of a weapon

_bag_chance -> chance to spawn a bag instead of a item

_max_magazines -> the maximum of magazines spawned in an itembox. 

_house_distance -> houses inside of this radius of a player will spawn loot

_exclude_loot -> you can add classnames there and those stuff will never spawn

_exclusive_loot -> add classnames here and nothing else will be spawned

_debug -> if true then u get hints about places were stuff was spawned or deleted and how many spawn places are active
*/

//***** EDIT BELOW TO ADJUST BEHAVIOR
_trigger_array = [];  //names of triggers or area markers in editor. if empty then spawning occures everywhere
_spawn_chance = 40;    //chance to spawn loot at specific house position
_item_chance = 30;   //chance to spawn an item instead of a weapon
_max_magazines = 4;    //maximum number of mags to spawn
_max_magazines_gl = 3; //maximum number of ammo to spawn for grenade launchers
_house_distance = 100;  // houses with that distance to players will spawn loot
_debug = false;  //information about number of places where items were spawned or deleted
//***** EDIT ABOVE TO ADJUST BEHAVIOR

//***** init variables
_checked_positions = [];
_spawned_positions = [];
_box_classname = "WeaponHolderSimulated_Scripted";

//***** get weapon and magazine classnames from config file
if (_spawn_chance > 0) then
{

 while {true} do
 {
  _actual_positions = [];
  _new_positions = [];
  _loot_players = [];
  _justPlayers = (allPlayers - entities "HeadlessClient_F") select {alive _x};

  //***** get desired spawn positions for loot in the buildings close to players
  //***** which are inside of a loot trigger area
  if(count _trigger_array > 0) then
  {
   {
    {
     _loot_players pushBack _x;
	 true
    } count (_justPlayers inAreaArray _x);
	true
   } count _trigger_array;
  }
  else
  {
   _loot_players = _justPlayers;
  };
  
  {
   {
    {
     if (!(_x in _checked_positions) && (random 100 < _spawn_chance)) then 
     {
      _new_positions pushBackUnique _x;
      _spawned_positions pushBackUnique _x;
     };
     _checked_positions pushBackUnique _x;
     _actual_positions pushBackUnique _x;
     true
    } count (_x buildingPos -1); 
    true
   }count (nearestObjects [_x, ["house","Building"], _house_distance]);
   true
  } count _loot_players;

  //***** delete loot out of range
  _checked_positions = _checked_positions select {_x in _actual_positions};
  _delete_positions = _spawned_positions select {!(_x in _actual_positions)};
  _spawned_positions = _spawned_positions - _delete_positions;

  _del_pos_num = count _delete_positions;

  {
   {
    deleteVehicle _x;
    true
   } count (nearestObjects [_x, [_box_classname], 3]);
   true
  } count _delete_positions;

  //***** spawn loot within 4 seconds (delay to prevent performance impact)
  _new_pos_num = count _new_positions;

  // debug things
  if(_debug) then
  {
   _spawned_num = count _spawned_positions;
   _checked_num = count _checked_positions;

   hint parseText format ["spawned new: %1, deleted old: %2 <br /> 
						spawned places: %3, overall places: %4", 
						_new_pos_num, _del_pos_num, _spawned_num, _checked_num];
  };

  if (_new_pos_num > 0) then
  {
   _sleep_delay = 4 / _new_pos_num;
   {
    _itembox = createVehicle [_box_classname, (_x vectorAdd [0, 0, 0.5]), [], 0.2, "NONE"];
   
    if (random 100 < _item_chance) then
    {
		if(random 100 > 70) then {
		
			_weaponlist = ["srifle_GM6_F","srifle_GM6_camo_F","arifle_Katiba_F","arifle_Katiba_C_F","arifle_Katiba_GL_F",
				"srifle_LRR_F","srifle_LRR_camo_F","srifle_EBR_F","arifle_Mk20_plain_F","arifle_Mk20_F",
				"arifle_Mk20_GL_plain_F","arifle_Mk20_GL_F","LMG_Mk200_F","arifle_Mk20C_plain_F","arifle_Mk20C_F",
				"arifle_MX_GL_Black_F","arifle_MX_GL_F","arifle_MX_Black_F","arifle_MX_F","arifle_MX_SW_Black_F",
				"arifle_MX_SW_F","arifle_MXC_Black_F","arifle_MXC_F","arifle_MXM_Black_F","arifle_MXM_F",
				"hgun_PDW2000_F","srifle_DMR_01_F","arifle_SDAR_F","SMG_02_F","arifle_TRG20_F",
				"arifle_TRG21_F","arifle_TRG21_GL_F","SMG_01_F","LMG_Zafir_F",
				"hgun_Pistol_heavy_01_F","hgun_ACPC2_F","hgun_P07_F","hgun_Rook40_F","hgun_Pistol_heavy_02_F",
				"arifle_Katiba_F","arifle_Katiba_C_F","arifle_Katiba_GL_F",
				"arifle_Mk20_plain_F","arifle_Mk20_F",
				"arifle_Mk20_GL_plain_F","arifle_Mk20_GL_F","arifle_Mk20C_plain_F","arifle_Mk20C_F",
				"arifle_MX_GL_Black_F","arifle_MX_GL_F","arifle_MX_Black_F","arifle_MX_F","arifle_MX_SW_Black_F",
				"arifle_MX_SW_F","arifle_MXC_Black_F","arifle_MXC_F","arifle_MXM_Black_F","arifle_MXM_F",
				"hgun_PDW2000_F","arifle_SDAR_F","SMG_02_F","arifle_TRG20_F",
				"arifle_TRG21_F","arifle_TRG21_GL_F","SMG_01_F",
				"hgun_Pistol_heavy_01_F","hgun_ACPC2_F","hgun_P07_F","hgun_Rook40_F","hgun_Pistol_heavy_02_F",
				"arifle_Katiba_F","arifle_Katiba_C_F",
				"arifle_Mk20_plain_F","arifle_Mk20_F","arifle_Mk20C_plain_F","arifle_Mk20C_F",
				"arifle_MX_Black_F","arifle_MX_F","arifle_MX_SW_Black_F",
				"arifle_MX_SW_F","arifle_MXC_Black_F","arifle_MXC_F",
				"hgun_PDW2000_F","arifle_SDAR_F","SMG_02_F","arifle_TRG20_F",
				"arifle_TRG21_F","SMG_01_F",
				"hgun_ACPC2_F","hgun_P07_F","hgun_Rook40_F",
				"arifle_Katiba_F","arifle_Katiba_C_F",
				"arifle_Mk20_plain_F","arifle_Mk20_F","arifle_Mk20C_plain_F","arifle_Mk20C_F",
				"arifle_MX_Black_F","arifle_MX_F","arifle_MX_SW_Black_F",
				"arifle_MX_SW_F","arifle_MXC_Black_F","arifle_MXC_F",
				"hgun_PDW2000_F","arifle_SDAR_F","SMG_02_F","arifle_TRG20_F",
				"arifle_TRG21_F","SMG_01_F",
				"hgun_ACPC2_F","hgun_P07_F","hgun_Rook40_F"];
			_weapon = _weaponlist call BIS_fnc_selectRandom;
			_muzzle_class = (getArray (configFile >> "CfgWeapons" >> _weapon >> "muzzles")) select 1;
			_muzzle_magazines = [];
			if !(isNil {_muzzle_class}) then
			{	
				_muzzle_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> _muzzle_class >> "magazines")
			};
			_weapons_and_mags = [_weapon, (getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")), _muzzle_magazines];

			_itembox addWeaponCargoGlobal [(_weapons_and_mags select 0), 1];
    
			for "_i" from 1 to (ceil random _max_magazines) do 
			{
				_itembox addMagazineCargoGlobal [(selectRandom (_weapons_and_mags select 1)), 1];
			};
	 
			if (count (_weapons_and_mags select 2) > 0) then
			{
			for "_i" from 1 to (ceil random _max_magazines_gl) do 
				{
					_itembox addMagazineCargoGlobal [(selectRandom (_weapons_and_mags select 2)), 1];
				};
			};
		};
		
		if(random 100 > 70) then {
			_magazinelist = ["5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag","7Rnd_408_Mag","20Rnd_762x51_Mag","200Rnd_65x39_cased_Box",
				"200Rnd_65x39_cased_Box_Tracer","150Rnd_762x54_Box","150Rnd_762x54_Box_Tracer","100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_mag_Tracer",
				"3Rnd_HE_Grenade_shell",
				"1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","UGL_FlareRed_F","UGL_FlareYellow_F",
				"UGL_FlareCIR_F","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeRed_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell",
				"1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell",
				"3Rnd_UGL_FlareWhite_F","3Rnd_UGL_FlareGreen_F","3Rnd_UGL_FlareRed_F","3Rnd_UGL_FlareYellow_F","3Rnd_UGL_FlareCIR_F",
				"3Rnd_Smoke_Grenade_shell","3Rnd_SmokeRed_Grenade_shell","3Rnd_SmokeGreen_Grenade_shell","3Rnd_SmokeYellow_Grenade_shell",
				"3Rnd_SmokePurple_Grenade_shell","3Rnd_SmokeBlue_Grenade_shell","3Rnd_SmokeOrange_Grenade_shell",
				"1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","UGL_FlareRed_F","UGL_FlareYellow_F",
				"UGL_FlareCIR_F","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeRed_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell",
				"1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell",
				"3Rnd_UGL_FlareWhite_F","3Rnd_UGL_FlareGreen_F","3Rnd_UGL_FlareRed_F","3Rnd_UGL_FlareYellow_F","3Rnd_UGL_FlareCIR_F",
				"3Rnd_Smoke_Grenade_shell","3Rnd_SmokeRed_Grenade_shell","3Rnd_SmokeGreen_Grenade_shell","3Rnd_SmokeYellow_Grenade_shell",
				"3Rnd_SmokePurple_Grenade_shell","3Rnd_SmokeBlue_Grenade_shell","3Rnd_SmokeOrange_Grenade_shell",
				"30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Green",
				"30Rnd_556x45_Stanag_Tracer_Yellow","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_green","30Rnd_65x39_caseless_mag",
				"30Rnd_65x39_caseless_mag_Tracer","11Rnd_45ACP_Mag","9Rnd_45ACP_Mag","6Rnd_45ACP_Cylinder",
				"30Rnd_9x21_Mag","30Rnd_9x21_Red_Mag","30Rnd_9x21_Yellow_Mag","30Rnd_9x21_Green_Mag","16Rnd_9x21_Mag",
				"16Rnd_9x21_red_Mag","16Rnd_9x21_green_Mag","16Rnd_9x21_yellow_Mag","10Rnd_762x54_Mag",
				"30Rnd_9x21_Mag_SMG_02","30Rnd_9x21_Mag_SMG_02_Tracer_Red","30Rnd_9x21_Mag_SMG_02_Tracer_Yellow","30Rnd_9x21_Mag_SMG_02_Tracer_Green",
				"30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow","30Rnd_45ACP_Mag_SMG_01_Tracer_Red","30Rnd_45ACP_Mag_SMG_01_Tracer_Green",
				"30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Green",
				"30Rnd_556x45_Stanag_Tracer_Yellow","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_green","30Rnd_65x39_caseless_mag",
				"30Rnd_65x39_caseless_mag_Tracer","11Rnd_45ACP_Mag","9Rnd_45ACP_Mag","6Rnd_45ACP_Cylinder",
				"30Rnd_9x21_Mag","30Rnd_9x21_Red_Mag","30Rnd_9x21_Yellow_Mag","30Rnd_9x21_Green_Mag","16Rnd_9x21_Mag",
				"16Rnd_9x21_red_Mag","16Rnd_9x21_green_Mag","16Rnd_9x21_yellow_Mag","10Rnd_762x54_Mag",
				"30Rnd_9x21_Mag_SMG_02","30Rnd_9x21_Mag_SMG_02_Tracer_Red","30Rnd_9x21_Mag_SMG_02_Tracer_Yellow","30Rnd_9x21_Mag_SMG_02_Tracer_Green",
				"30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow","30Rnd_45ACP_Mag_SMG_01_Tracer_Red","30Rnd_45ACP_Mag_SMG_01_Tracer_Green",
				"30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Green",
				"30Rnd_556x45_Stanag_Tracer_Yellow","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_green","30Rnd_65x39_caseless_mag",
				"30Rnd_65x39_caseless_mag_Tracer","11Rnd_45ACP_Mag","9Rnd_45ACP_Mag","6Rnd_45ACP_Cylinder",
				"30Rnd_9x21_Mag","30Rnd_9x21_Red_Mag","30Rnd_9x21_Yellow_Mag","30Rnd_9x21_Green_Mag","16Rnd_9x21_Mag",
				"16Rnd_9x21_red_Mag","16Rnd_9x21_green_Mag","16Rnd_9x21_yellow_Mag","10Rnd_762x54_Mag",
				"30Rnd_9x21_Mag_SMG_02","30Rnd_9x21_Mag_SMG_02_Tracer_Red","30Rnd_9x21_Mag_SMG_02_Tracer_Yellow","30Rnd_9x21_Mag_SMG_02_Tracer_Green",
				"30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow","30Rnd_45ACP_Mag_SMG_01_Tracer_Red","30Rnd_45ACP_Mag_SMG_01_Tracer_Green"];

			for "_i" from 1 to (ceil random _max_magazines) do 
			{
				_magazine = _magazinelist call BIS_fnc_selectRandom;
				_itembox addMagazineCargoGlobal [_magazine, 1];
			};
		};
		if(random 100 > 70) then {
			_uniformlist = ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt","U_I_G_resistanceLeader_F","U_I_CombatUniform","U_I_OfficerUniform",
						"U_I_CombatUniform_shortsleeve","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon",
						"U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_Competitor","U_B_CTRG_1","U_B_CTRG_3",
						"U_B_CTRG_2","U_C_Driver_1_black","U_C_Driver_1_blue","U_C_Driver_2","U_C_Driver_1",
						"U_C_Driver_1_green","U_C_Driver_1_orange","U_C_Driver_1_red","U_C_Driver_3","U_C_Driver_4",
						"U_C_Driver_1_white","U_C_Driver_1_yellow","U_O_CombatUniform_ocamo","U_O_CombatUniform_oucamo","U_I_FullGhillie_ard",
						"U_O_FullGhillie_ard","U_B_FullGhillie_ard","U_I_FullGhillie_lsh","U_O_FullGhillie_lsh","U_B_FullGhillie_lsh",
						"U_I_FullGhillie_sard","U_O_FullGhillie_sard","U_B_FullGhillie_sard","U_I_GhillieSuit","U_O_GhillieSuit",
						"U_B_GhillieSuit","U_BG_Guerrilla_6_1","U_BG_Guerilla1_1","U_BG_Guerilla2_2","U_BG_Guerilla2_1",
						"U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_BG_leader","U_I_HeliPilotCoveralls","U_B_HeliPilotCoveralls",
						"U_C_HunterBody_grn","U_OrestesBody","U_C_Journalist","U_Marshal","U_O_OfficerUniform_ocamo",
						"U_I_pilotCoveralls","U_O_PilotCoveralls","U_B_PilotCoveralls","U_Rangemaster","U_O_SpecopsUniform_ocamo",
						"U_B_CombatUniform_mcam_vest","U_C_Scientist","U_B_survival_uniform","U_I_Wetsuit","U_O_Wetsuit",
						"U_B_Wetsuit","U_C_WorkerCoveralls","U_C_Poor_1","U_I_G_Story_Protagonist_F","U_B_CombatUniform_mcam_worn",
						"U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt","U_I_G_resistanceLeader_F","U_I_CombatUniform","U_I_OfficerUniform",
						"U_I_CombatUniform_shortsleeve","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon",
						"U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_Competitor","U_B_CTRG_1","U_B_CTRG_3",
						"U_B_CTRG_2","U_C_Driver_1_black","U_C_Driver_1_blue","U_C_Driver_2","U_C_Driver_1",
						"U_C_Driver_1_green","U_C_Driver_1_orange","U_C_Driver_1_red","U_C_Driver_3","U_C_Driver_4",
						"U_C_Driver_1_white","U_C_Driver_1_yellow","U_O_CombatUniform_ocamo","U_O_CombatUniform_oucamo",
						"U_BG_Guerrilla_6_1","U_BG_Guerilla1_1","U_BG_Guerilla2_2","U_BG_Guerilla2_1",
						"U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_BG_leader","U_I_HeliPilotCoveralls","U_B_HeliPilotCoveralls",
						"U_C_HunterBody_grn","U_OrestesBody","U_C_Journalist","U_Marshal","U_O_OfficerUniform_ocamo",
						"U_I_pilotCoveralls","U_B_PilotCoveralls","U_Rangemaster","U_O_SpecopsUniform_ocamo",
						"U_B_CombatUniform_mcam_vest","U_C_Scientist","U_B_survival_uniform","U_I_Wetsuit","U_O_Wetsuit",
						"U_B_Wetsuit","U_C_WorkerCoveralls","U_C_Poor_1","U_I_G_Story_Protagonist_F","U_B_CombatUniform_mcam_worn"];
			_uniform1 = _uniformlist call BIS_fnc_selectRandom;
			_itembox addItemCargoGlobal [_uniform1, 1];
//			if (random 100 > 65) then {
//				_uniform2 = _uniformlist call BIS_fnc_selectRandom;
//				_itembox addItemCargoGlobal [_uniform2, 1];
//			};
		};
		if(random 100 > 80) then {
			_baglist = ["B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_dgtl","B_AssaultPack_rgr","B_AssaultPack_ocamo",
					"B_AssaultPack_khk","B_AssaultPack_mcamo","B_AssaultPack_sgg","B_Carryall_cbr","B_Carryall_ocamo",
					"B_Carryall_khk","B_Carryall_mcamo","B_Carryall_oli","B_Carryall_oucamo","B_FieldPack_blk",
					"B_FieldPack_cbr","B_FieldPack_ocamo","B_FieldPack_khk","B_FieldPack_oli","B_FieldPack_oucamo",
					"B_Kitbag_cbr","B_Kitbag_rgr","B_Kitbag_mcamo","B_Kitbag_sgg","B_TacticalPack_blk",
					"B_TacticalPack_rgr","B_TacticalPack_ocamo","B_TacticalPack_mcamo","B_TacticalPack_oli","B_AssaultPack_Kerry",
					"B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_dgtl","B_AssaultPack_rgr","B_AssaultPack_ocamo",
					"B_AssaultPack_khk","B_AssaultPack_mcamo","B_AssaultPack_sgg","B_FieldPack_blk",
					"B_FieldPack_cbr","B_FieldPack_ocamo","B_FieldPack_khk","B_FieldPack_oli","B_FieldPack_oucamo",
					"B_TacticalPack_blk",
					"B_TacticalPack_rgr","B_TacticalPack_ocamo","B_TacticalPack_mcamo","B_TacticalPack_oli","B_AssaultPack_Kerry"];
			_bag1 = _baglist call BIS_fnc_selectRandom;
			_itembox addBackpackCargoGlobal [_bag1, 1];
//			if (random 100 > 75) then {
//				_bag2 = _baglist call BIS_fnc_selectRandom;
//				_itembox addBackpackCargoGlobal [_bag2, 1];
//			};
		};
		
		if(random 100 > 45) then {
			_itemlist = ["Binocular","Rangefinder","NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP",
				"optic_ACO_grn","optic_Aco","optic_ACO_grn_smg","optic_Aco_smg","optic_Arco",
				"optic_DMS","optic_LRPS","optic_Holosight","optic_Holosight_smg","optic_SOS",
				"optic_MRCO","optic_Hamr","optic_Yorris","muzzle_snds_B","muzzle_snds_H",
				"muzzle_snds_M","muzzle_snds_H_MG","muzzle_snds_L","muzzle_snds_acp","optic_MRD",
				"ItemGPS","ItemCompass","ItemRadio","ItemMap",
				"MiniGrenade","HandGrenade","SmokeShellBlue","SmokeShellGreen","SmokeShellOrange",
				"SmokeShellPurple","SmokeShellRed","SmokeShell","SmokeShellYellow","APERSBoundingMine_Range_Mag",
				"APERSMine_Range_Mag","APERSTripMine_Wire_Mag","ATMine_Range_Mag","ClaymoreDirectionalMine_Remote_Mag","DemoCharge_Remote_Mag",
				"SatchelCharge_Remote_Mag","IEDLandBig_Remote_Mag","IEDUrbanBig_Remote_Mag","SLAMDirectionalMine_Wire_Mag","IEDLandSmall_Remote_Mag",
				"IEDUrbanSmall_Remote_Mag","MineDetector",
				"Binocular","Rangefinder","NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP",
				"optic_ACO_grn","optic_Aco","optic_ACO_grn_smg","optic_Aco_smg","optic_Arco",
				"optic_Holosight","optic_Holosight_smg",
				"optic_MRCO","optic_Hamr","optic_Yorris",
				"optic_MRD",
				"ItemGPS","ItemCompass","ItemRadio","ItemMap",
				"SmokeShellBlue","SmokeShellGreen","SmokeShellOrange",
				"SmokeShellPurple","SmokeShellRed","SmokeShell","SmokeShellYellow""MineDetector",
				"Binocular","NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP",
				"optic_ACO_grn","optic_Aco","optic_ACO_grn_smg","optic_Aco_smg",
				"optic_Holosight","optic_Holosight_smg",
				"optic_Yorris",
				"optic_MRD",
				"ItemGPS","ItemCompass","ItemRadio","ItemMap",
				"SmokeShellBlue","SmokeShellGreen","SmokeShellOrange",
				"SmokeShellPurple","SmokeShellRed","SmokeShell","SmokeShellYellow"];
			_item1 = _itemlist call BIS_fnc_selectRandom;
			_itembox addItemCargoGlobal [_item1, 1];
			if (random 100 > 45) then {
				_item2 = _itemlist call BIS_fnc_selectRandom;
				_itembox addItemCargoGlobal [_item2, 1];
			};
//			if (random 100 > 60) then {
//				_item3 = _itemlist call BIS_fnc_selectRandom;
//				_itembox addItemCargoGlobal [_item3, 1];
//			};
		};
		if(random 100 > 80) then {
			_itembox addItemCargoGlobal ["FirstAidKit", 1];
			if (random 100 > 80) then {
				_itembox addItemCargoGlobal ["FirstAidKit", 1];
			};
		};
		if(random 100 > 90) then {
			_vestlist = ["V_PlateCarrierGL_blk","V_PlateCarrierGL_rgr","V_PlateCarrierGL_mtp","V_PlateCarrier1_blk","V_PlateCarrier1_rgr",
						"V_PlateCarrier2_blk","V_PlateCarrier2_rgr","V_PlateCarrierSpec_blk","V_PlateCarrierSpec_rgr","V_PlateCarrierSpec_mtp",
						"V_Chestrig_blk","V_Chestrig_rgr","V_Chestrig_khk","V_Chestrig_oli","V_PlateCarrierL_CTRG",
						"V_PlateCarrierH_CTRG","V_PlateCarrierIAGL_dgtl","V_PlateCarrierIAGL_oli","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA2_dgtl",
						"V_HarnessOGL_brn","V_HarnessOGL_gry","V_HarnessO_brn","V_HarnessO_gry","V_Rangemaster_belt",
						"V_TacVestIR_blk","V_BandollierB_blk","V_BandollierB_cbr","V_BandollierB_rgr","V_BandollierB_khk",
						"V_BandollierB_oli","V_TacVest_blk","V_TacVest_brn","V_TacVest_camo","V_TacVest_khk",
						"V_TacVest_oli","V_TacVest_blk_POLICE","V_I_G_resistanceLeader_F","V_PlateCarrier_Kerry","V_Press_F",
						"V_PlateCarrier1_blk","V_PlateCarrier1_rgr",
						"V_Chestrig_blk","V_Chestrig_rgr","V_Chestrig_khk","V_Chestrig_oli","V_PlateCarrierL_CTRG",
						"V_PlateCarrierH_CTRG","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA2_dgtl",
						"V_HarnessOGL_brn","V_HarnessOGL_gry","V_HarnessO_brn","V_HarnessO_gry","V_Rangemaster_belt",
						"V_TacVestIR_blk","V_BandollierB_blk","V_BandollierB_cbr","V_BandollierB_rgr","V_BandollierB_khk",
						"V_BandollierB_oli","V_TacVest_blk","V_TacVest_brn","V_TacVest_camo","V_TacVest_khk",
						"V_TacVest_oli","V_TacVest_blk_POLICE","V_I_G_resistanceLeader_F","V_PlateCarrier_Kerry","V_Press_F"];
			_vest1 = _vestlist call BIS_fnc_selectRandom;
			_itembox addItemCargoGlobal [_vest1, 1];
//			if (random 100 > 85) then {
//				_vest2 = _vestlist call BIS_fnc_selectRandom;
//				_itembox addItemCargoGlobal [_vest2, 1];
//			};
		};
		if(random 100 > 85) then {
			_headgearlist = ["H_HelmetSpecO_blk","H_HelmetSpecO_ocamo","H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_cbr",
							"H_Bandanna_khk_hs","H_Bandanna_khk","H_Bandanna_mcamo","H_Bandanna_sgg","H_Bandanna_sand",
							"H_Bandanna_surfer","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_camo","H_Watchcap_blk",
							"H_Watchcap_cbr","H_Watchcap_camo","H_Watchcap_khk","H_Beret_blk","H_Beret_02",
							"H_Beret_Colonel","H_Booniehat_khk_hs","H_Booniehat_khk","H_Booniehat_mcamo","H_Booniehat_oli",
							"H_Booniehat_tan","H_Booniehat_dgtl","H_Cap_grn_BI","H_Cap_blk","H_Cap_blu",
							"H_Cap_blk_CMMG","H_Cap_grn","H_Cap_blk_ION","H_Cap_oli","H_Cap_oli_hs",
							"H_Cap_police","H_Cap_press","H_Cap_red","H_Cap_surfer","H_Cap_tan",
							"H_Cap_khaki_specops_UK","H_Cap_usblack","H_Cap_tan_specops_US","H_Cap_blk_Raven","H_Cap_brn_SPECOPS",
							"H_HelmetB","H_HelmetB_black","H_HelmetB_camo","H_HelmetB_desert","H_HelmetB_grass",
							"H_HelmetB_sand","H_HelmetB_snakeskin","H_HelmetCrew_I","H_HelmetCrew_O","H_HelmetCrew_B",
							"H_HelmetLeaderO_ocamo","H_HelmetLeaderO_oucamo","H_HelmetSpecB","H_HelmetSpecB_blk","H_HelmetSpecB_paint2",
							"H_HelmetSpecB_paint1","H_HelmetSpecB_sand","H_HelmetSpecB_snakeskin","H_Hat_blue","H_Hat_brown",
							"H_Hat_camo","H_Hat_checker","H_Hat_grey","H_Hat_tan","H_CrewHelmetHeli_I",
							"H_CrewHelmetHeli_O","H_CrewHelmetHeli_B","H_PilotHelmetHeli_I","H_PilotHelmetHeli_O","H_PilotHelmetHeli_B",
							"H_HelmetB_light","H_HelmetB_light_black","H_HelmetB_light_desert","H_HelmetB_light_grass","H_HelmetB_light_sand",
							"H_HelmetB_light_snakeskin","H_Cap_marshal","H_MilCap_blue","H_MilCap_gry","H_MilCap_ocamo",
							"H_MilCap_mcamo","H_MilCap_dgtl","H_HelmetIA","H_PilotHelmetFighter_I","H_PilotHelmetFighter_O",
							"H_PilotHelmetFighter_B","H_HelmetO_ocamo","H_HelmetO_oucamo","H_RacingHelmet_1_black_F","H_RacingHelmet_1_blue_F",
							"H_RacingHelmet_2_F","H_RacingHelmet_1_F","H_RacingHelmet_1_green_F","H_RacingHelmet_1_orange_F","H_RacingHelmet_1_red_F",
							"H_RacingHelmet_3_F","H_RacingHelmet_4_F","H_RacingHelmet_1_white_F","H_RacingHelmet_1_yellow_F","H_Cap_headphones",
							"H_Shemag_olive","H_Shemag_olive_hs","H_ShemagOpen_tan","H_ShemagOpen_khk","H_StrawHat",
							"H_StrawHat_dark",
							"H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_cbr",
							"H_Bandanna_khk_hs","H_Bandanna_khk","H_Bandanna_mcamo","H_Bandanna_sgg","H_Bandanna_sand",
							"H_Bandanna_surfer","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_camo","H_Watchcap_blk",
							"H_Watchcap_cbr","H_Watchcap_camo","H_Watchcap_khk","H_Beret_blk","H_Beret_02",
							"H_Beret_Colonel","H_Booniehat_khk_hs","H_Booniehat_khk","H_Booniehat_mcamo","H_Booniehat_oli",
							"H_Booniehat_tan","H_Booniehat_dgtl","H_Cap_grn_BI","H_Cap_blk","H_Cap_blu",
							"H_Cap_blk_CMMG","H_Cap_grn","H_Cap_blk_ION","H_Cap_oli","H_Cap_oli_hs",
							"H_Cap_police","H_Cap_press","H_Cap_red","H_Cap_surfer","H_Cap_tan",
							"H_Cap_khaki_specops_UK","H_Cap_usblack","H_Cap_tan_specops_US","H_Cap_blk_Raven","H_Cap_brn_SPECOPS",
							"H_HelmetB","H_HelmetB_black","H_HelmetB_camo","H_HelmetB_desert","H_HelmetB_grass",
							"H_HelmetB_sand","H_HelmetB_snakeskin","H_Hat_blue","H_Hat_brown",
							"H_Hat_camo","H_Hat_checker","H_Hat_grey","H_Hat_tan","H_CrewHelmetHeli_I",
							"H_CrewHelmetHeli_O","H_CrewHelmetHeli_B","H_PilotHelmetHeli_I","H_PilotHelmetHeli_O","H_PilotHelmetHeli_B",
							"H_HelmetB_light","H_HelmetB_light_black","H_HelmetB_light_desert","H_HelmetB_light_grass","H_HelmetB_light_sand",
							"H_HelmetB_light_snakeskin","H_Cap_marshal","H_MilCap_blue","H_MilCap_gry","H_MilCap_ocamo",
							"H_MilCap_mcamo","H_MilCap_dgtl","H_HelmetIA","H_PilotHelmetFighter_I","H_PilotHelmetFighter_O",
							"H_PilotHelmetFighter_B","H_HelmetO_ocamo","H_HelmetO_oucamo","H_RacingHelmet_1_black_F","H_RacingHelmet_1_blue_F",
							"H_RacingHelmet_2_F","H_RacingHelmet_1_F","H_RacingHelmet_1_green_F","H_RacingHelmet_1_orange_F","H_RacingHelmet_1_red_F",
							"H_RacingHelmet_3_F","H_RacingHelmet_4_F","H_RacingHelmet_1_white_F","H_RacingHelmet_1_yellow_F","H_Cap_headphones",
							"H_Shemag_olive","H_Shemag_olive_hs","H_ShemagOpen_tan","H_ShemagOpen_khk","H_StrawHat",
							"H_StrawHat_dark"];
			_headgear1 = _headgearlist call BIS_fnc_selectRandom;
			_itembox addItemCargoGlobal [_headgear1, 1];
//			if (random 100 > 80) then {
//				_headgear2 = _headgearlist call BIS_fnc_selectRandom;
//				_itembox addItemCargoGlobal [_headgear2, 1];
//			};
		};
		if(random 100 > 75) then {
			_gogglelist = ["G_Aviator","G_Balaclava_blk","G_Balaclava_combat","G_Balaclava_lowprofile","G_Balaclava_oli",
							"G_Bandanna_aviator","G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_khk","G_Bandanna_oli",
							"G_Bandanna_shades","G_Bandanna_sport","G_Bandanna_tan","G_Combat","G_Diving",
							"G_I_Diving","G_O_Diving","G_B_Diving","G_Lady_Blue","G_Lowprofile",
							"G_Shades_Black","G_Shades_Blue","G_Shades_Green","G_Shades_Red","G_Spectacles",
							"G_Sport_Red","G_Sport_Blackyellow","G_Sport_BlackWhite","G_Sport_Checkered","G_Sport_Blackred",
							"G_Sport_Greenblack","G_Squares_Tinted","G_Squares","G_Tactical_Clear","G_Tactical_Black",
							"G_Spectacles_Tinted","G_Goggles_VR"];
			_goggle1 = _gogglelist call BIS_fnc_selectRandom;
			_itembox addItemCargoGlobal [_goggle1, 1];
//			if (random 100 > 65) then {
//				_goggle2 = _gogglelist call BIS_fnc_selectRandom;
//				_itembox addItemCargoGlobal [_goggle2, 1];
//			};
		};
	};
    sleep _sleep_delay;
   } count _new_positions;
  };
  sleep (1 + random 2);
 };
};