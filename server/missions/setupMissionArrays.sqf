// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setupMissionArrays.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

MainMissions =
[
	["mission_AbandonedJet", 1],
	["mission_Convoy", 1],
	["mission_APC", 1],
	["mission_MBT", 1],
	["mission_LightArmVeh", 1],
	["mission_ArmedHeli", 1],
	["mission_CivHeli", 1],
	["mission_VTOL", 1],
	["mission_RedDawn", 1]
];

SideMissions =
[
	["mission_Coastal_Convoy", 1],
	["mission_Hackers", 1],
	["mission_HostageRescue", 1],
	["mission_AirWreck", 0.5],
	["mission_drugsRunners", 0.1],
	["mission_GeoCache", 0.1],
	["mission_WepCache", 0.1],
	["mission_MiniConvoy", 0.7],
	["mission_SunkenSupplies", 1],
	["mission_ArmedDiversquad", 0.5],
	["mission_Truck", 1]
];

MoneyMissions =
[
	["mission_altisPatrol", 1],
	["mission_militaryPatrol", 1],
	["mission_MoneyShipment", 1],
	["mission_SunkenTreasure", 0.5]
];

AssaultMissions = //using 509 mission files that have been modified
[
	["mission_Outpost", 1],
	["mission_Roadblock", 1],
	["mission_Smugglers", 1],
	["mission_Sniper", 0.7],
	["mission_TownInvasion", 1],
	["mission_KidnappedHero", 1]
];

 AirMissions = //using afgm OR 509 where not exists
[
	["mission_HostileHelicopter", 1],
	["mission_HostileHeliFormation", 1],
	["mission_HostileJet", 0.5],
	["mission_HostileJetFormation", 0.5],
	["mission_SkySmuggler", 1]
	//["mission_HostileVTOL", 1],
];

PriorityMissions = //using afgm OR 509 where not exists BUDDSKI7
[
	["mission_mechpatrol", 1],
	["mission_tankRush", 0.5],
	["mission_HillBurrow", 1]
]; 

TestMissions =
[
	//["mission_HillBurrow", 1]
	["mission_GunRunners", 1]
	
	
];


MissionSpawnMarkers = (allMapMarkers select {["Mission_", _x] call fn_startsWith}) apply {[_x, false]};
ForestMissionMarkers = (allMapMarkers select {["ForestMission_", _x] call fn_startsWith}) apply {[_x, false]};
SunkenMissionMarkers = (allMapMarkers select {["SunkenMission_", _x] call fn_startsWith}) apply {[_x, false]};
SniperMissionMarkers = (allMapMarkers select {["Sniper_", _x] call fn_startsWith}) apply {[_x, false]};
RoadblockMissionMarkers = (allMapMarkers select {["RoadBlockMission_", _x] call fn_startsWith}) apply {[_x, false]}; //buddski edit

LandConvoyPaths = (call compile preprocessFileLineNumbers "mapConfig\convoys\landConvoysList.sqf") apply {[_x, false]};
CoastalConvoyPaths = (call compile preprocessFileLineNumbers "mapConfig\convoys\coastalConvoysList.sqf") apply {[_x, false]};
PatrolConvoyPaths = (call compile preprocessFileLineNumbers "mapConfig\convoys\patrolConvoysList.sqf") apply {[_x, false]};
RushConvoyPaths = (call compile preprocessFileLineNumbers "mapConfig\convoys\rushConvoysList.sqf") apply {[_x, false]};

MainMissions = [MainMissions, [["A3W_heliPatrolMissions", ["mission_Coastal_Convoy"]], ["A3W_underWaterMissions", ["mission_ArmedDiversquad"]]]] call removeDisabledMissions;
SideMissions = [SideMissions, [["A3W_heliPatrolMissions", []], ["A3W_underWaterMissions", ["mission_SunkenSupplies"]]]] call removeDisabledMissions;
MoneyMissions = [MoneyMissions, [["A3W_underWaterMissions", ["mission_SunkenTreasure"]]]] call removeDisabledMissions;

// AirMissions = [AirMissions, []] call removeDisabledMissions; test deletion BUDDSKI edit
AirMissions = [AirMissions, [["A3W_heliPatrolMissions", ["mission_HostileVTOL", "mission_SkySmuggler"]]]] call removeDisabledMissions; //FROM 509

{ _x set [2, false] } forEach MainMissions;
{ _x set [2, false] } forEach SideMissions;
{ _x set [2, false] } forEach MoneyMissions;
{ _x set [2, false] } forEach AssaultMissions;
{ _x set [2, false] } forEach AirMissions;
{ _x set [2, false] } forEach PriorityMissions; //BUDDSKI7
{ _x set [2, false] } forEach TestMissions; //BUDDSKI7
