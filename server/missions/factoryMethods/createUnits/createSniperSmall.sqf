//	@file Version: 1.0
//	@file Name: smallGroup.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 21:58
//	@file Args:

if (!isServer) exitWith {};

private ["_group","_pos","_leader","_man2","_man3","_man4","_man5","_man6"];

_group = _this select 0;
_pos = _this select 1;

// Sniper
_leader = _group createUnit ["C_man_polo_1_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
_leader addUniform "U_I_Ghilliesuit";
_leader addVest "V_PlateCarrierIA1_dgtl";
_leader addMagazine "5Rnd_127x108_APDS_Mag";
_leader addWeapon "srifle_GM6_LRPS_F";
_leader addPrimaryWeaponItem "optic_Nightstalker";
_leader addMagazine "5Rnd_127x108_APDS_Mag";
_leader addMagazine "5Rnd_127x108_APDS_Mag";
_leader addMagazine "HandGrenade";

// Sniper
_man2 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 1, "Form"];
_man2 addUniform "U_I_Ghilliesuit";
_man2 addVest "V_PlateCarrierIA1_dgtl";
_man2 addMagazine "5Rnd_127x108_APDS_Mag";
_man2 addWeapon "srifle_GM6_LRPS_F";
_man2 addMagazine "5Rnd_127x108_APDS_Mag";
_man2 addMagazine "5Rnd_127x108_APDS_Mag";
_man2 addMagazine "HandGrenade";

// Spotter
_man4 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
_man4 addUniform "U_I_Ghilliesuit";
_man4 addVest "V_PlateCarrierIA1_dgtl";
_man4 addMagazine "10Rnd_338_Mag";
_man4 addWeapon "srifle_DMR_02_sniper_F";
_man4 addMagazine "10Rnd_338_Mag";
_man4 addMagazine "10Rnd_338_Mag";
_man4 addMagazine "HandGrenade";
_man4 addItem "Rangefinder";

// Spotter
_man5 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
_man5 addUniform "U_I_Ghilliesuit";
_man5 addVest "V_PlateCarrierIA1_dgtl";
_man5 addMagazine "10Rnd_338_Mag";
_man5 addWeapon "srifle_DMR_02_sniper_F";
_man5 addMagazine "10Rnd_338_Mag";
_man5 addMagazine "10Rnd_338_Mag";
_man5 addMagazine "HandGrenade";
_man5 addItem "Rangefinder";


sleep 0.1; // Without this delay, headgear doesn't get removed properly

_leader = leader _group;

{
	_x call setMissionSkill; 
	// setting skill for skillAI
	_x setSkill ["commanding", 1]; //added to test skill adjustment BUDDSKI aiskill
	_x setSkill ["spotDistance", .9]; //added to test skill adjustment BUDDSKI aiskill
	_x setSkill ["spotTime", .8]; //added to test skill adjustment BUDDSKI aiskill
	_x setSkill ["courage", 1]; //added to test skill adjustment BUDDSKI aiskill
	_x setSkill ["aimingSpeed", 8]; //added to test skill adjustment BUDDSKI aiskill
	_x setSkill ["reloadSpeed", .8]; //added to test skill adjustment BUDDSKI aiskill
	
	_x setSkill ["aimingAccuracy", 0.7]; //added to test skill adjustment BUDDSKI aiskill
	_x setSkill ["aimingShake", 0.7]; //added to test skill adjustment BUDDSKI aiskill
	// setting skils for precisionAI
	_x allowFleeing 0;
	_x addRating 9999999;
	_x addEventHandler ["Killed", server_playerDied];
} forEach units _group;
diag_log format ["SmallSniperCrew group formed %1", _group];

[_group, _pos] call defendAndCounter;
