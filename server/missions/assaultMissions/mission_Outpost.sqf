// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_VehicleCapture.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, JoSchaap, AgentRev
//	@file Created: 08/12/2012 15:19
//	@file Edit: 27/04/2018 by [509th] Coyote Rogue

if (!isServer) exitwith {};
#include "assaultMissionDefines.sqf";

private ["_nbUnits", "_outpost", "_objects", "_vehicle1", "_vehicle2"];

_moneyAmount = Tier_2_Reward; //Reward amount for completing mission

_setupVars =
{
	_missionType = "Enemy Outpost";
	_locationsArray = MissionSpawnMarkers;
	_nbUnits = AI_GROUP_MEDIUM;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete;
		
	_outpost = selectRandom (call compile preprocessFileLineNumbers "server\missions\outposts\outpostsList.sqf");
	_objects = [_outpost, _missionPos, 0] call createOutpost;

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits, 5] call createCustomGroup;
	
// Add Static AA System

//-------------------- FIND SAFE POSITION FOR OBJECTIVE
	_objPos1 = [_missionPos, 20, 150, 3, 0, 0.5, 0] call BIS_fnc_findSafePos;
	_objPos2 = [_missionPos, 30, 200, 3, 0, 0.5, 0] call BIS_fnc_findSafePos;	

	_vehicle1 = createVehicle ["O_Radar_System_02_F", _objPos1, [], 0, "NONE"];	
	_vehicle1 setVehicleReportRemoteTargets true;
	_vehicle1 setVehicleReceiveRemoteTargets true;
	_vehicle1 setVehicleRadar 1;
	_vehicle1 confirmSensorTarget [west, true];
	_vehicle1 confirmSensorTarget [east, true];
	_vehicle1 confirmSensorTarget [resistance, true];
	_vehicle1 setVariable [call vChecksum, true, false];	

	_vehicle2 = createVehicle ["O_SAM_System_04_F", _objPos2, [], 0, "NONE"];	
	_vehicle2 setVehicleReportRemoteTargets true;
	_vehicle2 setVehicleReceiveRemoteTargets true;
	_vehicle2 setVehicleRadar 1;
	_vehicle2 confirmSensorTarget [west, true];
	_vehicle2 confirmSensorTarget [east, true];
	_vehicle2 confirmSensorTarget [resistance, true];
	_vehicle2 setVariable [call vChecksum, true, false];		

	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach [_vehicle1, _vehicle2];	
	{ _x setVariable ["A3W_lockpickDisabled", true, true] } forEach [_vehicle1, _vehicle2];	

	_missionHintText = format ["An armed <t color='%1'>outpost</t> containing weapon crates has been spotted near the marker, go capture it!", assaultMissionColor]
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach _objects;
	{ deleteVehicle _x } forEach [_vehicle1, _vehicle2];	
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

		//Crate Behavior	
		
		{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach _objects; //Allows crates to be picked up and carried	
		[_locationsArray, _missionLocation, _objects] call setLocationObjects;

		_vehicle1 setDamage 1; // Destroy AA vehicles
		_vehicle2 setDamage 1; // Destroy AA vehicles		

		//Message
		
		_successHintMessage = "Great job! The outpost has been captured! Rewards are nearby.";

	};

_this call assaultMissionProcessor;
