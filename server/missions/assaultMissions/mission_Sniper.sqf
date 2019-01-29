// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_Sniper.sqf
//	@file Author: JoSchaap, AgentRev, LouD
//	@file Edit: 27/04/2018 by [509th] Coyote Rogue

if (!isServer) exitwith {};
#include "assaultMissionDefines.sqf";

private ["_positions", "_cash", "_moneyAmount", "_boxes1", "_box1", "_box2"];

_moneyAmount = Tier_3_Reward; //Reward amount for completing mission

_setupVars =
{
	_missionType = "Sniper Nest";
	_locationsArray = SniperMissionMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete;
		
	_aiGroup = createGroup CIVILIAN;
	[_aiGroup,_missionPos] call createsniperGroup;

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";

	_missionHintText = format ["A Sniper Nest has been spotted. Head to the marked area and Take them out! Be careful they are fully armed and dangerous!", assaultMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
// Mission failed
};

// Mission completed

	_successExec =
	{
		//Money - removed to balance effort vs reward
		
		/* for "_i" from 1 to 10 do
		{
			_cash = createVehicle ["Land_Money_F", _lastPos, [], 5, "NONE"];
			_cash setPos ([_lastPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
			_cash setDir random 360;
			_cash setVariable ["cmoney", _moneyAmount / 10, true];
			_cash setVariable ["owner", "world", true];
		}; */

		//Crates
					
		_boxes1 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F", "Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
		_box1 = createVehicle [_boxes1, _lastPos, [], 5, "NONE"];
		_box1 setDir random 360;
		_box1 call randomCrateLoadOut; // Randomly fills box with equipment
		_box1 allowDamage false;

		_box2 = createVehicle ["Box_NATO_WpsSpecial_F", _lastPos, [], 5, "NONE"];
		_box2 setDir random 360;
		[_box2, "mission_Main_A3snipers"] call fn_refillbox; // Fills from set list associated with type of box
		_box2 allowDamage false;
		
		//Crate Behavior	
		
		{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];	//Allows crates to be picked up and carried	

		//Message
		
		_successHintMessage = "The snipers are dead! Well Done!";

	};

_this call assaultMissionProcessor;
