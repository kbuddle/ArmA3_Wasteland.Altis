// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_Smugglers.sqf
//	@file Author: JoSchaap, AgentRev, LouD
//	@file Edit: 27/04/2018 by [509th] Coyote Rogue

if (!isServer) exitwith {};
#include "assaultMissionDefines.sqf";

private ["_positions", "_smugglerVeh", "_vehicle1", "_vehicle2", "_vehicle3", "_vehicle4", "_cash", "_moneyAmount", "_boxes1", "_boxes2", "_box1", "_box2"];

_moneyAmount = Tier_1_Reward; //Reward amount for completing mission	

_setupVars =
{
	_missionType = "Weapon Smugglers";

	_locationsArray = MissionSpawnMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete;
		
	_smugglerVeh =  selectRandom 
					[	
					"O_T_LSV_02_armed_F", // Quilin Minigun
					"B_T_LSV_01_armed_F", // Prowler HMG			  
					"I_APC_Wheeled_03_cannon_F", // AFV-4 Gorgon
					"B_AFV_Wheeled_01_cannon_F", // Rhino MGS
					"I_G_Offroad_01_armed_F", // Offroad Armed
					"B_MRAP_01_hmg_F", //Hunter HMG
					"O_MRAP_02_hmg_F", //Ifrit HMG
					"I_MRAP_03_hmg_F" // Strider HMG
					];

	_vehicle1 = [_smugglerVeh,[(_missionPos select 0) - 5, (_missionPos select 1) + 10,0],0.5,1,0,"NONE"] call createMissionVehicle;
	_vehicle1 setVehicleReportRemoteTargets true;
	_vehicle1 setVehicleReceiveRemoteTargets true;
	_vehicle1 setVehicleRadar 1;
	_vehicle1 confirmSensorTarget [west, true];
	_vehicle1 confirmSensorTarget [east, true];
	_vehicle1 confirmSensorTarget [resistance, true];
	_vehicle1 setVariable [call vChecksum, true, false];
	_vehicle1 setFuel 1;

	_vehicle2 = [_smugglerVeh,[(_missionPos select 0) - 5, (_missionPos select 1) - 10,0],0.5,1,0,"NONE"] call createMissionVehicle;
	_vehicle2 setVehicleReportRemoteTargets true;
	_vehicle2 setVehicleReceiveRemoteTargets true;
	_vehicle2 setVehicleRadar 1;
	_vehicle2 confirmSensorTarget [west, true];
	_vehicle2 confirmSensorTarget [east, true];
	_vehicle2 confirmSensorTarget [resistance, true];
	_vehicle2 setVariable [call vChecksum, true, false];
	_vehicle2 setFuel 1;

// Add Static AA System

//-------------------- FIND SAFE POSITION FOR OBJECTIVE
	_objPos1 = [_missionPos, 20, 200, 3, 0, 0.5, 0] call BIS_fnc_findSafePos;
	_objPos2 = [_missionPos, 30, 300, 3, 0, 0.5, 0] call BIS_fnc_findSafePos;	

	_vehicle3 = createVehicle ["O_Radar_System_02_F", _objPos1, [], 0, "NONE"];	
	_vehicle3 setVehicleReportRemoteTargets true;
	_vehicle3 setVehicleReceiveRemoteTargets true;
	_vehicle3 setVehicleRadar 1;
	_vehicle3 confirmSensorTarget [west, true];
	_vehicle3 confirmSensorTarget [east, true];
	_vehicle3 confirmSensorTarget [resistance, true];
	_vehicle3 setVariable [call vChecksum, true, false];	

	_vehicle4 = createVehicle ["O_SAM_System_04_F", _objPos2, [], 0, "NONE"];	
	_vehicle4 setVehicleReportRemoteTargets true;
	_vehicle4 setVehicleReceiveRemoteTargets true;
	_vehicle4 setVehicleRadar 1;
	_vehicle4 confirmSensorTarget [west, true];
	_vehicle4 confirmSensorTarget [east, true];
	_vehicle4 confirmSensorTarget [resistance, true];
	_vehicle4 setVariable [call vChecksum, true, false];		

	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach [_vehicle1, _vehicle2, _vehicle3, _vehicle4];	
	{ _x setVariable ["A3W_lockpickDisabled", true, true] } forEach [_vehicle1, _vehicle2, _vehicle3, _vehicle4];		

	_Boxes1 = selectRandom ["c_supplyCrate_F","c_IDAP_supplyCrate_F","Box_FIA_Wps_F","Box_FIA_Ammo_F"];
	_box1 = createVehicle [_Boxes1,[(_missionPos select 0), (_missionPos select 1),0],[], 0, "NONE"];
	_box1 call randomCrateLoadOut; // Randomly fills box with equipment
	_box1 allowDamage false;
	_box1 setVariable ["moveable", true, true];
	_box1 setVariable ["R3F_LOG_disabled", true, true];

	_Boxes2 = selectRandom ["B_CargoNet_01_Ammo_F","O_CargoNet_01_Ammo_F","I_CargoNet_01_Ammo_F"];
	_box2 = createVehicle [_Boxes2,[(_missionPos select 0) - 5, (_missionPos select 1) - 8,0],[], 0, "NONE"];
	_box2 call randomCrateLoadOut; // Randomly fills box with equipment
	_box2 allowDamage false;
	_box2 setVariable ["moveable", true, true];
	_box2 setVariable ["R3F_LOG_disabled", true, true];

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup,_missionPos] call createsmugglerGroup;

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";

	_missionPicture = getText (configFile >> "CfgVehicles" >> _smugglerVeh >> "picture");

	_missionHintText = format ["A group of weapon smugglers have been spotted. Stop the weapons deal and take their stuff.", assaultMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_box1, _box2, _vehicle1, _vehicle2, _vehicle3, _vehicle4];
};

// Mission completed
	
	_successExec =
	{
		{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];
		{ _x setVariable ["A3W_missionVehicle", true] } forEach [_vehicle1, _vehicle2];
	
		_vehicle1 setVehicleLock "UNLOCKED";
		_vehicle2 setVehicleLock "UNLOCKED";
		_vehicle3 setDamage 1;
		_vehicle4 setDamage 1;
	
		//Money
		
		for "_i" from 1 to 10 do
		{
			_cash = createVehicle ["Land_Money_F", _missionPos, [], 5, "NONE"];
			_cash setPos ([_missionPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
			_cash setDir random 360;
			_cash setVariable ["cmoney", _moneyAmount / 10, true];
			_cash setVariable ["owner", "world", true];
		};

	//Message
	
	_successHintMessage = format ["You brought it! The smugglers are dead. Although they destroyed the AA vehicles, the other weapons and money are yours!"];
};

_this call assaultMissionProcessor;
