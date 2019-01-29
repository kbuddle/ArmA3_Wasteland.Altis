// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: customGroup.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_group", "_pos", "_nbUnits", "_unitTypes", "_uPos", "_unit"];

_group = _this select 0;
_pos = _this select 1;
_nbUnits = param [2, 7, [0]];
_radius = param [3, 10, [0]];

_unitTypes =
[
	"C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro",
	"C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F",
	"C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F",
	"C_man_p_beggar_F","C_man_p_beggar_F_afro",
	"C_man_p_fugitive_F","C_journalist_F","C_Orestes",
	"C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F",
	"C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F",
	"C_man_w_worker_F","C_man_p_beggar_F","C_man_p_beggar_F_afro",
	"C_man_p_fugitive_F"
];

for "_i" from 1 to _nbUnits do
{
	_uPos = _pos vectorAdd ([[random _radius, 0, 0], random 360] call BIS_fnc_rotateVector2D);
	_unit = _group createUnit [_unitTypes call BIS_fnc_selectRandom, _uPos, [], 0, "Form"];
	_unit setPosATL _uPos;

	removeAllWeapons _unit;
	removeAllAssignedItems _unit;
	removeVest _unit;
	removeBackpack _unit;
	_unit addVest "V_PlateCarrier1_rgr";
	_unit addMagazine "30Rnd_556x45_Stanag";
	_unit addMagazine "30Rnd_556x45_Stanag";
	_unit addMagazine "30Rnd_556x45_Stanag";

	switch (true) do
	{
		// Grenadier every 3 units
		case (_i % 3 == 0):
		{
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addWeapon "arifle_TRG21_GL_F";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
		};
		// RPG every 7 units, starting from second one
		case ((_i + 5) % 7 == 0):
		{
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addWeapon "arifle_TRG20_F";
			_unit addMagazine "Titan_AT";
			_unit addWeapon "launch_Titan_short_F";
			_unit addMagazine "Titan_AT";
			_unit addMagazine "Titan_AT";
		};
		// Rifleman
		default
		{
			if (_unit == leader _group) then
			{
				_unit addWeapon "arifle_TRG21_F";
				_unit addMagazine "HandGrenade";
				_unit setRank "SERGEANT";
			}
			else
			{
				_unit addWeapon "arifle_TRG20_F";
				_unit addMagazine "HandGrenade";
			};
		};
	};

	_unit addPrimaryWeaponItem "acc_flashlight";
	_unit enablegunlights "forceOn";

	_unit addRating 1e11;
	_unit spawn refillPrimaryAmmo;
//	_unit call setMissionSkill;
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
	
	_unit addEventHandler ["Killed", server_playerDied];
};

[_group, _pos] call defendArea;
