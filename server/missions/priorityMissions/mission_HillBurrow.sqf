// Hill Burrow Teams

if (!isServer) exitwith {};
#include "priorityMissionDefines.sqf";
// REWARDS
private ["_missionType", "_positions", "_cash", "_moneyAmount", "_boxes1", "_box1", "_box2", "_aigroup"];

// BUILDINGS

private ["_missionPos", "_missionLocation","_setupObjects", "_objs", "_basetoDelete", "_buildings" ];
// WEAPONS

private ["_basetoDelete", "_units", "_staticWeapons", "_vehicleType", "_crewSize", "_targetCrew", "_i"];
// TEAMS

private ["_Team1", "_Team1Pos", "_Team1NBUnits", "_Team1Radius", "_units1", "_insideT1"];
private ["_Team2", "_Team2Pos", "_Team2NBUnits", "_Team2Radius", "_units2"];
private ["_Team3", "_Team3Pos", "_Team3NBUnits", "_Team3Radius", "_units3"];
private ["_Team4", "_Team4Pos", "_Team4NBUnits", "_Team4Radius", "_units4"];
private ["_Team5", "_Team5Pos", "_Team5NBUnits", "_Team5Radius", "_units5"];
private ["_Team6", "_Team6Pos", "_Team6NBUnits", "_Team6Radius", "_units6"];
private ["_Team7", "_Team7Pos", "_Team7NBUnits", "_Team7Radius", "_units7"];
private ["_Team8", "_Team8Pos", "_Team8NBUnits", "_Team8Radius", "_units8"];
private ["_Team9", "_Team9Pos", "_Team9NBUnits", "_Team9Radius", "_units9"];
private ["_Team10", "_Team10Pos", "_Team10NBUnits", "_Team10Radius", "_units10"];
private ["_Team11", "_Team11Pos", "_Team11NBUnits", "_Team11Radius", "_units11"];
private ["_Team12", "_Team12Pos", "_Team12NBUnits", "_Team12Radius", "_units12"];
private ["_TeamHQ", "_TeamHQPos", "_TeamHQNBUnits", "_TeamHQRadius", "_unitsHQ", "_insideHQ"];

//diag_log format ["HELL MISSION variables declared"];

_moneyAmount = Tier_3_Reward * 4; //Reward amount for completing mission

_setupVars =
{
	_missionType = "Hell Hill";
	_missionPos = [6287,12138];
	_missionLocation = "Hell Hill";

	// MISSION ai variables
	_Team1Pos = [6096.165, 11848.745, 0.745]; 	//cross valley bunker - 2HMG Static, 6 crew, Sergeant lead
	_Team1NBUnits = 6;
	_Team1Radius = 5; 							//ensure placement inside building

	_Team2Pos = [6495.602, 12185.507, 0]; 		//Small bunker SE
	_Team2NBUnits = 3;
	_Team2Radius = 3; 							//ensure placement inside building

	_Team3Pos = [6576.775, 12281.731, 0]; 		//Small bunker NE
	_Team3NBUnits = 3;
	_Team3Radius = 3; 							//ensure placement inside building

	_Team4Pos = [6446.667, 12410.555, 0]; 		//Small bunker N
	_Team4NBUnits = 3;
	_Team4Radius = 3; 							//ensure placement inside building

	_Team5Pos = [6329.486, 12351.265, 0]; 		//Small bunker NW
	_Team5NBUnits = 3;
	_Team5Radius = 3; 							//ensure placement inside building

	_Team6Pos = [6540.065, 12325.381, 0]; 		// Roam1 North
	_Team6NBUnits = 10;
	_Team6Radius = 15; 
	
	_Team7Pos = [6535.065, 12319.381, 0]; 		// Roam2 North East
	_Team7NBUnits = 10;
	_Team7Radius = 15; 

	_Team8Pos = [6386.214, 12139.758, 0]; 		// Roam3 Valley
	_Team8NBUnits = 10;
	_Team8Radius = 15;

	_Team9Pos = [6096.165, 11848.745, 0.745]; 	//Sniper Team cross valley
	_Team9NBUnits = 4; 							//set by create procedure

	_Team10Pos = [6304.938, 12238.894, 0]; 		//Sniper Team north west
	_Team10NBUnits = 4; 						//set by create procedure

	_Team11Pos = [6422.016, 12318.854, 0]; 		//AA Team
	_Team11NBUnits = 5;
	_Team11Radius = 5; 							//ensure placement inside building

	_Team12Pos = [6370.1, 12293.28, 0]; 		//AT Team
	_Team12NBUnits = 5;
	_Team12Radius = 5; 							//ensure placement inside building

	_TeamHQPos = [6433.349, 12164.16, 1.256]; 	//HQ bunker - 6 crew - Major lead
	_TeamHQNBUnits = 7;
	_TeamHQRadius = 8; 							//ensure placement inside building
};
//diag_log format ["HELL MISSION variables initialised"];
_setupObjects =
{
	// CLEAR THE MISSION AREA OF BUILDINGS AND OBJECTS
	_missionPos = [6433.349,12164.16]; // centre of all mission for object clearance

	//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [[6287,12138], ["All"], 360];
	{ deleteVehicle _x } forEach _baseToDelete;

 	// CREATE THE MISSION BUILDINGS
	// _filename = "HillBurrow";

	_objs = call createHillBurrowBuildings2;

//diag_log format ["HELL MISSION %1 buildings created"];

	// CREATE THE MISSION STATIC WEAPONS

	_vehicles = call createHillBurrowWeapons; 
	
//diag_log format ["HELL MISSION %1 weapons created"];

	// CREATE THE MISSION CHARACTERS	
	_aigroup = createGroup CIVILIAN;
	[_aigroup, _TeamHQPos, _TeamHQNBUnits, _TeamHQRadius] call createCustomGroup6; 
	_aigroup setCombatMode "RED";
	_aigroup setBehaviour "COMBAT";
	
	[_aiGroup, _TeamHQPos, 50, false, false] call moveIntoBuildings; //HEADQUARTERS
	
	{_x disableAI "PATH"} forEach units _aigroup;

//diag_log format ["HELL MISSION HQ TEAM %1", count (units _aigroup)];
	
	_Team1 = createGroup CIVILIAN;
	[_Team1, _Team1Pos, _Team1NBUnits, _Team1Radius] call createSmallBunkerCrew; 
	_Team1 setCombatMode "RED";
	_Team1 setBehaviour "COMBAT";
		
	[_Team1, _Team1Pos, 10, false, false] call moveIntoBuildings; //Cross Valley Bunker

	{_x disableAI "PATH"} forEach units _Team1;
//diag_log format ["HELL MISSION  team1 count %1", count (units _Team1)];

	_Team2 = createGroup CIVILIAN;
	[_Team2, _Team2Pos, _Team2NBUnits, _Team2Radius] call createSmallBunkerCrew; 
	_Team2 setCombatMode "RED";
	_Team2 setBehaviour "COMBAT";
	[_Team2, _Team2Pos, 20, false, false] call moveIntoBuildings; //Small bunker SE

//diag_log format ["HELL MISSION  team2 count %1", count (units _Team2)];

	_Team3 = createGroup CIVILIAN;
	[_Team3, _Team3Pos, _Team3NBUnits, _Team3Radius] call createSmallBunkerCrew; //Small bunker NE
	_Team3 setCombatMode "RED";
	_Team3 setBehaviour "COMBAT";
	
	[_Team1, _Team1Pos, 10, false, false] call moveIntoBuildings; //Cross Valley Bunker

//diag_log format ["HELL MISSION  team3 count %1", count (units _Team3)];

	_Team4 = createGroup CIVILIAN;
	[_Team4, _Team4Pos, _Team4NBUnits, _Team4Radius] call createSmallBunkerCrew; //Small bunker N
	_Team4 setCombatMode "RED";
	_Team4 setBehaviour "COMBAT";
	
//diag_log format ["HELL MISSION  team4 count %1", count (units _Team4)];	

	_Team5 = createGroup CIVILIAN;
	[_Team5, _Team5Pos, _Team5NBUnits, _Team5Radius] call createSmallBunkerCrew; //Small bunker NW
	_Team5 setCombatMode "RED";
	_Team5 setBehaviour "COMBAT";
	
//diag_log format ["HELL MISSION  team5 count %1", count (units _Team5)];	

	_Team6 = createGroup CIVILIAN;
	[_Team6, _Team6Pos, _Team6NBUnits, _Team6Radius] call createCustomGroup3; 	// Roam1 North
	_Team6 setCombatMode "RED";
	_Team6 setBehaviour "COMBAT";
	
//diag_log format ["HELL MISSION  team6 count %1", count (units _Team6)];	

	_Team7 = createGroup CIVILIAN;
	[_Team7, _Team7Pos, _Team7NBUnits, _Team7Radius] call createCustomGroup3; 	// Roam2 North East
	_Team7 setCombatMode "RED";
	_Team7 setBehaviour "COMBAT";
	
//diag_log format ["HELL MISSION  team7 count %1", count (units _Team7)];	

	_Team8 = createGroup CIVILIAN;
	[_Team8, _Team8Pos, _Team8NBUnits, _Team8Radius] call createCustomGroup3; 	// Roam3 Valley
	_Team8 setCombatMode "RED";
	_Team8 setBehaviour "COMBAT";
	
//diag_log format ["HELL MISSION  team8 count %1", count (units _Team8)];	

	_Team9 = createGroup CIVILIAN;
	[_Team9, _Team9Pos] call createSniperSmall; 								//Sniper Team cross valley
	_Team9 setCombatMode "RED";
	_Team9 setBehaviour "COMBAT";
	 
//diag_log format ["HELL MISSION  team9 count %1", count (units _Team9)];	

	_Team10 = createGroup CIVILIAN;
	[_Team10, _Team10Pos] call createSniperSmall; 								//Sniper Team north west
	_Team10 setCombatMode "RED";
	_Team10 setBehaviour "COMBAT";
	
//diag_log format ["HELL MISSION  team10 count %1", count (units _Team10)];	

	_Team11 = createGroup CIVILIAN;
	[_Team11, _Team11Pos, _Team11NBUnits, _Team11Radius] call createAATeam;
	_Team11 setCombatMode "RED";
	_Team11 setBehaviour "COMBAT";
	
//diag_log format ["HELL MISSION  team11 count %1", count (units _Team11)];	

	_Team12 = createGroup CIVILIAN;
	[_Team12, _Team12Pos, _Team12NBUnits, _Team12Radius] call createATTeam;
	_Team12 setCombatMode "RED";
	_Team12 setBehaviour "COMBAT";
	
//diag_log format ["HELL MISSION  team12 count %1", count (units _Team12)];	

	{[_x] joinSilent _aiGroup} forEach (Units _Team1);
	{[_x] joinSilent _aiGroup} forEach (Units _Team2);
	{[_x] joinSilent _aiGroup} forEach (Units _Team3);
	{[_x] joinSilent _aiGroup} forEach (Units _Team4);
	{[_x] joinSilent _aiGroup} forEach (Units _Team5);
	{[_x] joinSilent _aiGroup} forEach (Units _Team6);
	{[_x] joinSilent _aiGroup} forEach (Units _Team7);
	{[_x] joinSilent _aiGroup} forEach (Units _Team8);
	{[_x] joinSilent _aiGroup} forEach (Units _Team9);
	{[_x] joinSilent _aiGroup} forEach (Units _Team10);
	{[_x] joinSilent _aiGroup} forEach (Units _Team11);
	{[_x] joinSilent _aiGroup} forEach (Units _Team12);
	
	_crewSize = count (units _aigroup);

//	diag_log format ["HELL MISSION  AIGROUP has target crew of 73 troops vs spawned %1 troops", _crewSize];

	_missionHintText = format ["A large skilled team has dug into <t color='%1'> Hill Burrow</t>. Clear the valley of the resistance and claim a prize worthy of a lordship! There are multiple well armed threats, take a team with you and be careful!", PriorityMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;
//_waitUntilSuccessCondition = {!alive leader _aiGroup};
//_ignoreAiDeaths = nil;

_failedExec =
{
// Mission failed
	
	{ deleteVehicle _x } forEach _objs;
	{ deleteVehicle _x } forEach _vehicle;	
};

// Mission completed

	_successExec =
	{
		//Money - removed to balance effort vs reward
		
		for "_i" from 1 to 5 do
		{
			_cash = createVehicle ["Land_Money_F", _TeamHQPos, [], 2, "NONE"];
			_cash setPos ([_TeamHQPos, [[1 + random 0.5,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
			_cash setDir random 360;
			_cash setVariable ["cmoney", _moneyAmount / 5, true];
			_cash setVariable ["owner", "world", true];
		};

		//Crates
		sleep 2;
					
		// _boxes1 = selectRandom ["Box_NATO_Equip_F", "Box_IND_Support_F","Box_IND_WpsLaunch_F"];
		
		_box1 = createVehicle ["Box_NATO_Equip_F", [6435.677, 12159.932, 1.73], [], 0, "NONE"];
		_box1 call randomCrateLoadOut; // Randomly fills box with equipment
		_box1 allowDamage false;

		_box2 = createVehicle ["Box_T-East_Wps_F", [6433.265, 12160, 1.73], [], 0, "NONE"];
		_box1 call randomCrateLoadOut; // Randomly fills box with equipment
		_box2 allowDamage false;
		
		//Crate Behavior	
		
		{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];	//Allows crates to be picked up and carried	

		//Message
		
		_successHintMessage = "The chief is dead and the loot is now yours, watch out for any further surprises as you collect!";

	};

_this call priorityMissionProcessor;






