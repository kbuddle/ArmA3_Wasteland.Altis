// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_RoadBlock.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, JoSchaap, AgentRev, soulkobk
//	@file Created: 08/12/2012 15:19
//	@file Modified: 4:31 PM 06/07/2016 (soulkobk)
//	@file Edit: 27/04/2018 by [509th] Coyote Rogue

if (!isServer) exitwith {};

#include "assaultMissionDefines.sqf";

private ["_nbUnits", "_roadBlock", "_objects", "_loadout", "_boxes1", "_boxes2", "_box1", "_box2"];

_moneyAmount = Tier_2_Reward;  
//_moneyAmount = 100000; //Reward amount for completing mission

_setupVars =
{
	_missionType = "Road Block";
	_locationsArray = RoadBlockMissionMarkers;
};
_setupObjects =
{
	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
	_missionPos = markerPos _missionLocation;

	//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete;
		
	_missionDir = markerDir _missionLocation;
	_roadBlock = selectRandom (call compile preprocessFileLineNumbers "server\missions\roadBlocks\roadBlockList.sqf");
	_objects = [_roadBlock, _missionPos, _missionDir] call createRoadBlock;
	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach _objects;
	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits, 15] call createCustomGroup;
	_missionHintText = format ["Enemies have set up a road block and are stopping all traffic! Go and take it over!", assaultMissionColor];
	
	//Crates
	
	_boxes1 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F","Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
	_box1 = createVehicle [_boxes1,[(_missionPos select 0), (_missionPos select 1),0],[], 0, "NONE"];
	_box1 call randomCrateLoadOut; // Randomly fills box with equipment
	_box1 allowDamage false;
	_box1 setVariable ["moveable", true, true];	
	_box1 setVariable ["R3F_LOG_disabled", true, true];

	_boxes2 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F","Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
	_box2 = createVehicle [_boxes2,[(_missionPos select 0) - 5, (_missionPos select 1) - 8,0],[], 0, "NONE"];
	_box2 call randomCrateLoadOut; // Randomly fills box with equipment
	_box2 allowDamage false;
	_box2 setVariable ["moveable", true, true];	
	_box2 setVariable ["R3F_LOG_disabled", true, true];		
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	{ deleteVehicle _x } forEach _objects;
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

		{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach _objects;		
		{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];	//Allows crates to be picked up and carried		

		//Message
		
		_successHintMessage = "The road block has been taken over. Great work!";
	};

_this call assaultMissionProcessor;
