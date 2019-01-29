// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: tankRush.sqf
//	@file Author: WitchDoctor [GGO]
//	@file Edit: 27/04/2018 by [509th] Coyote Rogue

if (!isServer) exitwith {};
#include "PriorityMissionDefines.sqf";

private ["_convoyVeh","_veh1","_veh2","_veh3","_veh4","_veh5","_veh6","_veh7","_veh8","_veh9","_veh10","_createVehicle","_vehicles", "_leader", "_speedMode", "_waypoint", "_vehicleName", "_numWaypoints", "_boxes1", "_boxes2", "_boxes3", "_boxes4", "_boxes5", "_box1", "_box2", "_box3", "_box4", "_box5", "_cash", "_moneyAmount", "_smokemarker"];

_moneyAmount = Tier_4_Reward * 2; //Reward amount for completing mission

_setupVars =
{
	_missionType = "Tank Blitz";
	_locationsArray = rushConvoyPaths;

};

_setupObjects =
{
	private ["_starts", "_startDirs", "_waypoints"];
	call compile preprocessFileLineNumbers format ["mapConfig\convoys\%1.sqf", _missionLocation];

	// Pick the vehicles for the patrol. Only one set at the moment. Will add more later.
	_convoyVeh = selectRandom	
	[
	["B_MBT_01_TUSK_F", "B_MBT_01_TUSK_F", "B_MBT_01_TUSK_F", "B_APC_Tracked_01_AA_F", "B_APC_Tracked_01_AA_F", "B_APC_Tracked_01_AA_F", "B_MBT_01_cannon_F", "B_MBT_01_cannon_F", "B_APC_Tracked_01_rcws_F", "B_AFV_Wheeled_01_cannon_F"], // BluFor Patrol
	["O_MBT_04_command_F", "O_MBT_04_cannon_F", "O_MBT_04_cannon_F", "O_APC_Tracked_02_AA_F", "O_APC_Tracked_02_AA_F", "O_APC_Tracked_02_AA_F", "O_MBT_02_cannon_F", "O_MBT_02_cannon_F", "O_MBT_02_cannon_F", "O_APC_Tracked_02_cannon_F"] // OpFor  Patrol
	];
	
	_veh1 = _convoyVeh select 0;
	_veh2 = _convoyVeh select 1;
	_veh3 = _convoyVeh select 2;
	_veh4 = _convoyVeh select 3;
	_veh5 = _convoyVeh select 4;
	_veh6 = _convoyVeh select 5; 
	_veh7 = _convoyVeh select 6;
	_veh8 = _convoyVeh select 7;
	_veh9 = _convoyVeh select 8;
	_veh10 = _convoyVeh select 9;

  _createVehicle = {
		private ["_type","_position","_direction","_vehicle","_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "NONE"];
		[_vehicle] call vehicleSetup;

		// apply tropical textures to vehicles on Tanoa
		if (worldName == "Tanoa" && _type select [1,3] != "_T_") then
		{
			switch (toUpper (_type select [0,2])) do
			{
				case "B_": { [_vehicle, ["Olive"]] call applyVehicleTexture };
				case "O_": { [_vehicle, ["GreenHex"]] call applyVehicleTexture };
			};
		};

		_vehicle setDir _direction;
		_aiGroup addVehicle _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInDriver _vehicle;		
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInGunner _vehicle;
		_soldier = [_aiGroup, _position] call createRandomSoldier;		
			if (_vehicle emptyPositions "commander" > 0) then
			{
				_soldier moveInCommander _vehicle;
			}
			else
			{
				_soldier moveInCargo [_vehicle, 1];
			};
	
		_vehicle setVariable ["R3F_LOG_disabled", true, true]; // force vehicles to be locked
		[_vehicle, _aiGroup] spawn checkMissionVehicleLock; // force vehicles to be locked

		_vehicle
	};

	_aiGroup = createGroup CIVILIAN;

	_vehicles =
	[
		[_veh1, _starts select 0, _startDirs select 0] call _createVehicle,
		[_veh2, _starts select 1, _startDirs select 1] call _createVehicle,
		[_veh3, _starts select 2, _startDirs select 2] call _createVehicle,
		[_veh4, _starts select 3, _startDirs select 3] call _createVehicle,
		[_veh5, _starts select 4, _startDirs select 4] call _createVehicle,
		[_veh6, _starts select 5, _startDirs select 5] call _createVehicle,
		[_veh7, _starts select 6, _startDirs select 6] call _createVehicle,
		[_veh8, _starts select 7, _startDirs select 7] call _createVehicle,
		[_veh9, _starts select 8, _startDirs select 8] call _createVehicle,
		[_veh10, _starts select 9, _startDirs select 9] call _createVehicle
	];
 
	sleep 1;
	
	_leader = effectiveCommander (_vehicles select 0);
	_aiGroup selectLeader _leader;
	_leader setRank "LIEUTENANT";
	_aiGroup setCombatMode "YELLOW"; // GREEN = Hold fire, Defend only; YELLOW = Fire at will;  RED = Fire at will, engage at will
	_aiGroup setBehaviour "SAFE"; // SAFE = Defend only; AWARE = (default) Take action when enemy is noted; COMBAT = Always alert
	_aiGroup setFormation "FILE"; //COLUMN - Line up single file behind unit 1; STAG COLUMN - Two columns offset, left column leads; FILE - Same as COLUMN, except tighter.

	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" }; //"LIMITED" (half speed); "NORMAL" (full speed, maintain formation); "FULL" (do not wait for any other units in formation)

	_aiGroup setSpeedMode _speedMode;

	sleep 1;
	
	{
		_waypoint = _aiGroup addWaypoint [_x, 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 50;
		_waypoint setWaypointCombatMode "YELLOW"; // GREEN = Hold fire, Defend only; YELLOW = Fire at will;  RED = Fire at will, engage at will
		_waypoint setWaypointBehaviour "SAFE"; // SAFE = Defend only; AWARE = (default) Take action when enemy is noted; COMBAT = Always alert
		_waypoint setWaypointFormation "FILE"; //COLUMN - Line up single file behind unit 1; STAG COLUMN - Two columns offset, left column leads; FILE - Same as COLUMN, except tighter.
		_waypoint setWaypointSpeed _speedMode;
	} forEach _waypoints;

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _veh6 >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _veh2 >> "displayName");
	_vehicleName2 = getText (configFile >> "CfgVehicles" >> _veh6 >> "displayName");
	_vehicleName3 = getText (configFile >> "CfgVehicles" >> _veh9 >> "displayName");

	_missionHintText = format ["A convoy containing at least<br/>a <t color='%4'>%1</t>, <br/>a <t color='%4'>%2</t> and <br/>a <t color='%4'>%3</t> is patrolling a high value location! Stop the patrol and collect the high value weapons crate and money!", _vehicleName, _vehicleName2, _vehicleName3, PriorityMissionColor];

	_numWaypoints = count waypoints _aiGroup;
};

_waitUntilMarkerPos = {getPosATL _leader};
_waitUntilExec = nil;
_waitUntilCondition = {currentWaypoint _aiGroup >= _numWaypoints};

_failedExec = nil;

// Mission completed

	_successExec =
	{
		//Money
		
		for "_i" from 1 to 10 do
		{
			_cash = createVehicle ["Land_Money_F", _lastPos, [], 5, "NONE"];
			_cash setPos ([_lastPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
			_cash setDir random 360;
			_cash setVariable ["cmoney", _moneyAmount / 10, true];
			_cash setVariable ["owner", "world", true];
		};

		//Crates
					
		_boxes1 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F", "Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
		_box1 = createVehicle [_boxes1, _lastPos, [], 5, "NONE"];
		_box1 setDir random 360;
		_box1 call randomCrateLoadOut; // Randomly fills box with equipment
		_box1 allowDamage false;

		_boxes2 = ["airdrop_launchers","airdrop_weapons","airdrop_ordinance","airdrop_ammo","airdrop_supplies"] call BIS_fnc_selectRandom;
		_box2 = createVehicle ["Box_NATO_WpsSpecial_F", _lastPos, [], 5, "NONE"];
		_box2 setDir random 360;
		[_box2, _boxes2] call fn_refillbox; // Fills from set list associated with type of box	
		_box2 allowDamage false;
		
		_box3 = createVehicle ["Box_NATO_WpsLaunch_F", _lastPos, [], 5, "None"];
		_box3 setDir random 360;
		[_box3, "airdrop_launchers"] call fn_refillbox; //Launcher box
		_box3 allowDamage false;		

		_boxes4 = ["mission_USLaunchers","mission_USSpecial","mission_Main_A3snipers"] call BIS_fnc_selectRandom;
		_box4 = createVehicle ["Box_NATO_WpsSpecial_F", _lastPos, [], 5, "NONE"];
		_box4 setDir random 360;
		[_box4, _boxes4] call fn_refillbox; // Fills from set list associated with type of box	
		_box4 allowDamage false;

		_box5 = createVehicle ["Box_NATO_Equip_F", _lastPos, [], 5, "None"];
		_box5 setDir random 360;
		[_box5, "special_mass"] call fn_refillbox; //Special large box
		_box5 allowDamage false;		
		
		//Crate Behavior	
		
		{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2, _box3,_box4, _box5];	//Allows crates to be picked up and carried	
		
		//Smoke to mark the crates
		_smokemarker = createMarker ["SMMarker1", _lastPos];
		[_smokemarker] spawn CrateSmoke; //Calls repeating green smoke grenade
		uiSleep 2;		
		deleteMarker "SMMarker1"; 			

		//Message
		
		_successHintMessage = "Great job! You've busted those tanks! Rewards are nearby.";

	};

_this call PriorityMissionProcessor;
