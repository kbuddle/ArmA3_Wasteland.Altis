// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: customGroup.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_group", "_pos", "_nbUnits", "_unitTypes", "_uPos", "_unit"];

_group = _this select 0;
_pos = _this select 1;
_nbUnits = _this select 2;
_radius =  _this select 3; // param [3, 10, [0]];
 diag_log format ["CUSTOMGROUP5 - _group %1, _pos %2, _NBUnits %3, _radius %4", _group, _pos, _nbUnits, _radius ];
_unitTypes =
[
	"C_man_polo_1_F", "C_man_polo_1_F_euro", "C_man_polo_1_F_afro", "C_man_polo_1_F_asia",
	"C_man_polo_2_F", "C_man_polo_2_F_euro", "C_man_polo_2_F_afro", "C_man_polo_2_F_asia",
	"C_man_polo_3_F", "C_man_polo_3_F_euro", "C_man_polo_3_F_afro", "C_man_polo_3_F_asia",
	"C_man_polo_4_F", "C_man_polo_4_F_euro", "C_man_polo_4_F_afro", "C_man_polo_4_F_asia",
	"C_man_polo_5_F", "C_man_polo_5_F_euro", "C_man_polo_5_F_afro", "C_man_polo_5_F_asia",
	"C_man_polo_6_F", "C_man_polo_6_F_euro", "C_man_polo_6_F_afro", "C_man_polo_6_F_asia"
];

for "_i" from 1 to _nbUnits do
{
	_uPos = _pos vectorAdd ([[random _radius, 0, 0], random 360] call BIS_fnc_rotateVector2D);
	_unit = _group createUnit [_unitTypes call BIS_fnc_selectRandom, _uPos, [], 0, "Form"];
	_unit setPosATL _uPos;
 diag_log format ["CUSTOMGROUP5 - _unit %1", _unit];
	removeAllWeapons _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;

	_unit addVest "V_PlateCarrier1_rgr";
	_unit addMagazine "30Rnd_556x45_Stanag";
	_unit addMagazine "30Rnd_556x45_Stanag";
	_unit addMagazine "30Rnd_556x45_Stanag";

	switch (true) do
	{
		// Grenadier every 3 units
		case (_i % 3 == 0):
		{
			_unit addUniform "U_B_CombatUniform_mcam_vest";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addWeapon "arifle_TRG21_GL_F";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
		};	
		// SMG every 4 units
		case (_i % 4 == 0):
		{
			_unit addUniform "U_B_CombatUniform_mcam_tshirt";
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addWeapon "SMG_01_F";
			_unit addMagazine "30Rnd_45ACP_MAG_SMG_01";
			_unit addMagazine "30Rnd_45ACP_MAG_SMG_01";
			_unit addMagazine "30Rnd_45ACP_MAG_SMG_01";
		};

		// RPG every 7 units
		case (_i % 7 == 0):
		{
			_unit addUniform "U_B_CombatUniform_mcam_tshirt";
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addWeapon "arifle_TRG20_F";
			_unit addMagazine "RPG32_HE_F";
			_unit addWeapon "launch_RPG32_F";
			_unit addMagazine "RPG32_HE_F";
			_unit addMagazine "RPG32_HE_F";
		};
		// Rifleman
		default
		{
			
			if (_unit == leader _group) then
			{
				_unit addUniform "U_B_HeliPilotCoveralls";
				_unit addWeapon "arifle_TRG21_F";
				_unit addMagazine "HandGrenade";
				_unit setRank "SERGEANT";
				_unit addMagazine "HandGrenade";
			}
			else
			{
				_unit addUniform "U_B_CombatUniform_mcam";
				_unit addWeapon "arifle_TRG20_F";
				_unit addMagazine "HandGrenade";
				_unit addMagazine "HandGrenade";
				_unit addMagazine "HandGrenade";
			};
		};
	};

	_unit addPrimaryWeaponItem "acc_flashlight";
	_unit enablegunlights "forceOn";

	_unit addRating 1e11;
	_unit spawn addMilCap;
	_unit spawn refillPrimaryAmmo;
	_unit call setMissionSkill;
	_unit addEventHandler ["Killed", server_playerDied];
};
diag_log format ["CUSTOMGROUP5 group formed %1", _group];
[_group, _pos] call defendAndCounter;
