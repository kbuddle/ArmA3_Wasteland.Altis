// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*
 =======================================================================================================================
Script: BIN_taskDefend.sqf v1.3a (defendAndCounter.sqf)
Author(s): Binesi, AgentRev, BUDDSKI
Partly based on original code by BIS

BUDDSKI extended the concept to define _wp2 based on last known enemy position

Description:
Group will guard/patrol the position and surrounding area.

Parameter(s):
_this select 0: group (Group)
_this select 1: defense position (Array)
_this select 2: Vehicle class to move in as gunner (String, optional)

Returns:
Boolean - success flag

Example(s):
[group this, getPos this] call defendAndCounter;
=======================================================================================================================
*/
// diag_log format ["TEST MISSION - defendAndCounter has been called"]; //BuddskiDEBUG
if (!isServer) exitWith {};

private ["_closePatrol", "_huntPatrol","_grp", "_pos", "_vehicleType", "_lastContact"];
//terminate _closePatrol;
//terminate _huntPatrol;
_lastContact = 3*60;
_grp = _this select 0;
_pos = _this select 1;
_vehicleType = if (count _this > 2) then { _this select 2 } else { "StaticWeapon" };

_grp allowFleeing 0;

// Static weapons
private ["_units", "_staticWeapons", "_unit"];
_units = (units _grp) - [leader _grp]; // The leader should not man defenses
_staticWeapons = [];

// Find all nearby static defenses or vehicles without a gunner
{
	if (_x emptyPositions "gunner" > 0) then
	{
		_staticWeapons pushBack _x;
	};
} forEach (nearestObjects [_pos, [_vehicleType], 75]);

// Have the group man empty static defenses and vehicle turrets
{
	// Are there still units available?
	if (count _units > 0) then
	{
		_unit = _units call BIS_fnc_selectRandom;
		_unit assignAsGunner _x;
		_unit moveInGunner _x;
		_units = _units - [_unit];
	};
} forEach _staticWeapons;

//	exitwith terminate _closePatrol	;																		
{
	// Prevent units from wandering from going prone
	[_x, _pos] spawn
	{
		private ["_unit", "_unitPos", "_targetPos", "_doMove"];
		_unit = _this select 0;
		_targetPos = ATLtoASL (_this select 1);

		while {alive _unit} do
		{
			if ((toUpper behaviour _unit) in ["COMBAT","STEALTH"]) then
			{
				if (stance _unit == "PRONE") then
				{
					_unit setUnitPos "MIDDLE";
				};
			}
			else
			{
				if (unitPos _unit == "MIDDLE") then
				{
					_unit setUnitPos "AUTO";
				};
			};

			sleep 1;

/*			if (!isNull _unit) then //disabled routine to stop them going to far, handle with patrol methodology
			{
				_unitPos = getPosASL _unit;

				if (_unitPos vectorDistance _targetPos > 75) then
				{
					_doMove = [[0, 5 + random 65, 0], -(([_targetPos, _unitPos] call BIS_fnc_dirTo) + (45 - random 90))] call BIS_fnc_rotateVector2D;
					_unit moveTo (_targetPos vectorAdd _doMove);
					sleep 3;
				};
			}; */
		};
	};

	_x disableAI "COVER";
} forEach units _grp;

_grp spawn
{
	while {{alive _x} count units _this > 0} do
	{
		if (combatMode _this != "RED") then
		{
			_this setCombatMode "RED"; // FIRE AT WILL MOTHERFUCKERS!
		};

		sleep 3;
	};
};
/****************************************************************************
Hunting routine - BUDDSKI
*****************************************************************************/

private [ "_nearbyEnemy", "_searchDistance", "_searchTime","_proximity", "_searchTime", "_lastKnown", "_lastKnownPos", "_leader", "_lastKnownEnemy"];
_leader = [];
_searchTime = 0;

_leader = leader _grp;



while {({alive _x} count units _grp) > 0} do 															// keep looking while ai group is alive
{ 
	
//	diag_log format ["TEST MISSION DEFEND AND COUNTER - close patrol has commenced with %1 remaining units", _units];
	
	while {alive _leader} do 
	{	
		_nearbyEnemy = _leader findNearestEnemy _pos;
	
		_lastKnownPos = (_leader targetKnowledge _nearbyEnemy) select 6;
	
		_proximity = _pos distance _lastKnownPos;
	
		_lastKnown = _leader knowsAbout _nearbyEnemy;

		_lastKnownEnemy = (_leader targetKnowledge _nearbyEnemy) select 1;
		
	

	
		if ((_lastKnown > 0.5) && (_proximity < 500)) then //IF SOMEONE NEAR THEN STOP PATROL
		{
			_huntPatrol = [_grp, _lastKnownPos, 150] call BIS_fnc_taskPatrol; 
//			diag_log format ["TEST MISSION DEFEND AND COUNTER - close patrol has been terminated"];
			sleep 5;
			
		};
		
		while {(_lastKnown > 0.5) && (_proximity < 500) && (_lastKnownEnemy) } do  //NEEDS SOME CONFIDENCE, MUST BE CLOSE ENOUGH, KNOW ABOUT ENEMY, KEEP GOING FOR UP TO 2 MINUTES
		{
			
			sleep 5;
			
			_searchDistance = (_leader distance _pos);
		
			_nearbyEnemy = _leader findNearestEnemy _pos;

			_searchTime = serverTime - ((_leader targetKnowledge _nearbyEnemy) select 2);

			_lastKnownEnemy = (_leader targetKnowledge _nearbyEnemy) select 1;
			
			_lastKnownPos = (_leader targetKnowledge _nearbyEnemy) select 6;
	
			_proximity = _pos distance _lastKnownPos;
	
			_lastKnown = _leader knowsAbout _nearbyEnemy;
			//diag_log format ["TEST MISSION DEFEND AND COUNTER - while hunting last know %1, proximity %2, lastknownenemy %3, searchtime %4, NEARBY ENEMY %5", _lastKnown, _proximity, _lastKnownEnemy, _searchTime, (group _nearbyEnemy)];
			
			//sleep 5;
			_huntPatrol = [_grp, _lastKnownPos, 100] call BIS_fnc_taskPatrol; 
//			diag_log format ["TEST MISSION DEFEND AND COUNTER - HUNTPatrolling location %1", _lastKnownPos];

		} exitWith {_HuntPatrol = true};
		
		_closePatrol = [_grp, _pos, 100] call BIS_fnc_taskPatrol; 
//		diag_log format ["TEST MISSION DEFEND AND COUNTER - CLOSEPatrolling ORIGINAL LOCATION %1", _pos];
		sleep 5;
	} exitWith {_closePatrol=true};
	_closePatrol = [_grp, _pos, 100] call BIS_fnc_taskPatrol; 
//	diag_log format ["TEST MISSION DEFEND AND COUNTER - close Patrolling without leader at location %1", _Pos];
	sleep 5;	
};

true
