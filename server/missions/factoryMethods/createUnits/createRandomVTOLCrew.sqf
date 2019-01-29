//	@file Name: createRandomVTOLCrew.sqf
/*
 * Creates a random civilian soldier.
 *
 * Arguments: [ position, group, init, skill, rank]: Array
 *    position: Position - Location unit is created at.
 *    group: Group - Existing group new unit will join.
 *    init: String - (optional, default "") Command to be executed upon creation of unit. Parameter this is set to the created unit and passed to the code.
 *    skill: Number - (optional, default 0.5)
 *    rank: String - (optional, default "PRIVATE")
 */

if (!isServer) exitWith {};

private ["_soldierTypes","_uniformTypes","_vestTypes","_backpackTypes","_weaponTypes", "_launcherTypes", "_group","_position","_soldier"];

_soldierTypes = ["C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F"];
_uniformTypes = ["U_O_PilotCoveralls"];
_vestTypes = ["V_PlateCarrierIA2_dgtl","V_PlateCarrierH_CTRG"];
_backpackTypes = ["B_Parachute"];
_weaponTypes = ["arifle_MX_SW_Hamr_pointer_F","LMG_Mk200_F","arifle_MXM_F","srifle_DMR_05_tan_f", "MMG_01_hex_ARCO_LP_F", "MMG_02_black_RCO_BI_F", "arifle_SPAR_03_blk_MOS_Pointer_Bipod_F", "srifle_DMR_02_MRCO_F"];
_launcherTypes = ["launch_O_Titan_short_F","launch_B_Titan_F","launch_NLAW_F","launch_MRAWS_olive_rail_F", "launch_O_Vorona_brown_F", "launch_RPG7_F"];

_group = _this select 0;
_position = _this select 1;

_soldier = _group createUnit [_soldierTypes call BIS_fnc_selectRandom, _position, [], 0, "NONE"];
_soldier addUniform (_uniformTypes call BIS_fnc_selectRandom);
_soldier addVest (_vestTypes call BIS_fnc_selectRandom);
_soldier addBackpack (_backpackTypes call BIS_fnc_selectRandom);
_soldier addMagazine "HandGrenade";

/*Add MPRL
_soldier addMagazine "Titan_AA";
_soldier addWeapon "launch_B_Titan_F";
*/

[_soldier, _weaponTypes call BIS_fnc_selectRandom, 3] call BIS_fnc_addWeapon;
[_soldier, _launcherTypes call BIS_fnc_selectRandom, 4] call BIS_fnc_addWeapon;

sleep 0.1; // Without this delay, headgear doesn't get removed properly

removeAllAssignedItems _soldier;
_soldier addHeadgear "H_HelmetLeaderO_oucamo";

_soldier spawn refillPrimaryAmmo;
_soldier call setMissionSkill;

_soldier addEventHandler ["Killed", server_playerDied];

_soldier
