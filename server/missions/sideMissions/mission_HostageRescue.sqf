// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_HostageRescue.sqf
//	@file Author: JoSchaap, AgentRev, GriffinZS, RickB, soulkobk

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_positions", "_camonet", "_hostage", "_obj1", "_obj3", "_obj4", "_vehicleName", "_chair", "_cash", "_moneyAmount"];

_moneyAmount = Tier_2_Reward; //Reward amount for completing mission

_setupVars =
{
	_missionType = "Hostage Rescue";
	_locationsArray = MissionSpawnMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete;

	_camonet = createVehicle ["CamoNet_INDP_open_F", [_missionPos select 0, _missionPos select 1], [], 0, "CAN_COLLIDE"];
	_camonet allowdamage false;
	_camonet setDir random 360;
	_camonet setVariable ["R3F_LOG_disabled", false];

	_missionPos = getPosATL _camonet;

	_chair = createVehicle ["Land_Slums02_pole", _missionPos, [], 0, "CAN_COLLIDE"];
	_chair setPosATL [_missionPos select 0, _missionPos select 1, _missionPos select 2];

	_hostage = createVehicle ["C_Nikos_aged", _missionPos, [], 0, "CAN_COLLIDE"];
	_hostage setPosATL [_missionPos select 0, _missionPos select 1, _missionPos select 2];
	waitUntil {alive _hostage};
	[_hostage, "Acts_AidlPsitMstpSsurWnonDnon_loop"] call switchMoveGlobal;
	_hostage disableAI "anim";

	_obj1 = createVehicle ["I_GMG_01_high_F", _missionPos,[], 10,"NONE"];
	_obj1 setPosATL [(_missionPos select 0) - 2, (_missionPos select 1) + 2, _missionPos select 2];

	_obj3 = createVehicle ["I_HMG_01_high_F", _missionPos,[], 10,"NONE"];
	_obj3 setPosATL [(_missionPos select 0) - 2, (_missionPos select 1) - 2, _missionPos select 2];

	_obj4 = createVehicle ["I_HMG_01_high_F", _missionPos,[], 10,"NONE"];
	_obj4 setPosATL [(_missionPos select 0) + 2, (_missionPos select 1) - 2, _missionPos select 2];


	_aiGroup = createGroup CIVILIAN;
	[_aiGroup,_missionPos,10,20] call createCustomGroup7;

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";

	_vehicleName = "Hostage";
	_missionHintText = format ["<br/>Mercenary soldiers have captured a merchant and are demanding a ransom. <br/> Free the merchant and collect his reward", _vehicleName, sideMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = {!alive _hostage};

_failedExec =
{
	// Mission failed

	{ deleteVehicle _x } forEach [_camonet, _obj1, _obj3, _obj4, _hostage, _chair];
	_failedHintMessage = format ["The merchant is dead! The mission has failed. Re-training in hostage rescue is needed."];
};

// Mission completed

	_successExec =
	{
		//Money
		
		for "_i" from 1 to 10 do
		{
			_cash = createVehicle ["Land_Money_F", _missionPos, [], 5, "NONE"];
			_cash setPos ([_missionPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
			_cash setDir random 360;
			_cash setVariable ["cmoney", _moneyAmount / 10, true];
			_cash setVariable ["owner", "world", true];
		};

		{ deleteVehicle _x } forEach [_hostage, _chair];
		{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_obj1, _obj3, _obj4];

		//Message
		
		_successHintMessage = "Well done! The mercenary soldiers are dead and the merchant is alive. Collect the reward.";

	};

_this call SideMissionProcessor;
