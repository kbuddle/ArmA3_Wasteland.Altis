// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 2.1
//	@file Name: mission_mechPatrol.sqf
//	@file Author: JoSchaap / routes by Del1te - (original idea by Sanjo), AgentRev
//	@file Created: 31/08/2013 18:19
//	@file Edit: 27/04/2018 by [509th] Coyote Rogue

if (!isServer) exitwith {};
#include "PriorityMissionDefines.sqf";

private ["_mechPatrol", "_moneyAmount", "_convoys", "_vehChoices", "_moneyText", "_vehClasses", "_createVehicle", "_vehicles", "_veh2", "_leader", "_speedMode", "_waypoint", "_vehicleName", "_numWaypoints", "_cash", "_boxes1","_boxes2", "_boxes3", "_boxes4", "_boxes5", "_box1", "_box2", "_box3", "_box4", "_box5"];

_setupVars =
{
	// _locationsArray = nil;

	// Mechanized Patrol settings
	// Difficulties : Min = 1, Max = infinite
	// Convoys per difficulty : Min = 1, Max = infinite
	// Vehicles per convoy : Min = 1, Max = infinite
	// Choices per vehicle : Min = 1, Max = infinite
	
	_mechPatrol = selectRandom
	[
		// Easy
		[
			"Quick Attack", // Marker text
			Tier_1_Reward, // Money
			[
				[ // NATO convoy
					["B_LSV_01_AT_F", "B_LSV_01_armed_black_F"], // Veh 1 - Prowler			
					["B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F"], // Veh 2 - Hunter	
					["B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F",  "B_G_Offroad_01_armed_F"] // Veh 3 - Offroad
	
				],
				[ // CSAT convoy
					["O_T_LSV_02_armed_F", "O_T_LSV_02_AT_F"], // Veh 1 - Quilin		
					["O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F"], // Veh 2 - Ifrit
					["O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F",  "O_G_Offroad_01_armed_F"] // Veh 3 - Offroad
			
				],
				[ // AAF convoy
					["I_C_Offroad_02_LMG_F", "I_C_Offroad_02_AT_F"], // Veh 1 - MB 4WD	
					["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F"], // Veh 2 - Strider		
					["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F",  "I_G_Offroad_01_armed_F"] // Veh 3 - Offroad		
				]
			]
		],

		// Light
		[
			"Light Mechanized", // Marker text
			Tier_2_Reward, // Money
			[
				[ // NATO convoy
					["B_LSV_01_AT_F", "B_LSV_01_armed_black_F", "B_G_Offroad_01_armed_F"], // Veh 1 - Prowler, Offroad		
					["B_AFV_Wheeled_01_cannon_F", "B_AFV_Wheeled_01_up_cannon_F", "B_APC_Wheeled_03_cannon_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F"], // Veh 2 - APC - Rhino, Rhino MGS Up, Gorgon, Marshall, Panther   	
					["B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F"], // Veh 3 - Hunter
					["B_APC_Tracked_01_AA_F"] // Veh 4 - AA	- Cheetah			
				],

				[ // CSAT convoy
					["O_T_LSV_02_armed_F", "O_T_LSV_02_AT_F", "O_G_Offroad_01_armed_F"], // Veh 1 - Quilin, Offroad
					["O_APC_Tracked_02_cannon_F", "O_APC_Wheeled_02_rcws_v2_F"], // Veh 2 - APC - Madrid, Kamysh 
					["O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F"], // Veh 3 - Ifrit
					["O_APC_Tracked_02_AA_F"] // Veh 4 - AA - Tigris 	
				],

				[ // AAF convoy
					["I_C_Offroad_02_LMG_F", "I_C_Offroad_02_AT_F",  "I_G_Offroad_01_armed_F"], // Veh 1 - MB 4WD, Offroad
					["I_APC_Wheeled_03_cannon_F", "I_APC_tracked_03_cannon_F"], // Veh 2 - APC - Gorgon, Mora 
					["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F"], // Veh 3 - Strider
					["B_APC_Tracked_01_AA_F"] // Veh 4 - AA -	
				]
			]
		],
		// Medium
		[
			"Medium Mechanized", // Marker text
			Tier_3_Reward, // Money
			[
				[ // NATO convoy
					["B_LSV_01_AT_F", "B_LSV_01_armed_black_F", "B_G_Offroad_01_armed_F"], // Veh 1 - Prowler, Offroad				
					["B_APC_Tracked_01_AA_F"], // Veh 2 - AA	- Cheetah
					["B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F"], // Veh 3 - Hunter
					["B_AFV_Wheeled_01_cannon_F", "B_AFV_Wheeled_01_up_cannon_F", "B_APC_Wheeled_03_cannon_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F"], // Veh 4 - APC - Rhino, Rhino MGS Up, Gorgon, Marshall, Panther 	
					["B_Heli_Light_01_armed_F", "B_Heli_Attack_01_F"], // Veh 5 - Air - Pawnee, Blackfoot
					["B_MBT_01_cannon_F", "B_MBT_01_TUSK_F"], // Veh 6 - Tank - Slammer, Slammer UP 					
					["B_MBT_01_cannon_F", "B_MBT_01_TUSK_F"] // Veh 7 - Tank
				],
				[ // CSAT convoy
					["O_T_LSV_02_armed_F", "O_T_LSV_02_AT_F", "O_G_Offroad_01_armed_F"], // Veh 1 - Offroad
					["O_APC_Tracked_02_AA_F"], // Veh 2	- AA
					["O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F"], // Veh 3 - Ifrit
					["O_APC_Tracked_02_cannon_F", "O_APC_Wheeled_02_rcws_v2_F"], // Veh 4 - APC - Madrid, Kamysh 				
					["O_Heli_Light_02_F", "O_Heli_Attack_02_black_F"], // Veh 5 - Air - Orca, Kajman
					["O_MBT_02_cannon_F", "O_MBT_04_cannon_F", "O_MBT_04_command_F"], // Veh 6 - Tank - Varsuk, Angara, Angara (Command) 
					["O_MBT_02_cannon_F", "O_MBT_04_cannon_F", "O_MBT_04_command_F"] // Veh 7 - Tank
				],
				[ // AAF convoy
					["I_C_Offroad_02_LMG_F", "I_C_Offroad_02_AT_F",  "I_G_Offroad_01_armed_F"], // Veh 1 - Offroad
					["I_APC_Wheeled_03_cannon_F", "I_APC_tracked_03_cannon_F"], // Veh 2 - APC	
					["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F"], // Veh 3 - Strider	
					["I_Heli_light_03_F"], // Veh 4- Air
					["I_MBT_03_cannon_F"], // Veh 5 - Tank
					["B_APC_Tracked_01_AA_F"], // Veh 6 - AA	
					["I_MBT_03_cannon_F", "I_APC_Wheeled_03_cannon_F", "I_APC_tracked_03_cannon_F"] // Veh 7 - APC				
				]
			]
		],

		// Heavy
		[
			"Heavy Mechanized", // Marker text
			Tier_4_Reward, // Money
			[
				[ // NATO convoy
					["B_LSV_01_AT_F", "B_LSV_01_armed_black_F", "B_G_Offroad_01_armed_F"], // Veh 1 - Offroad		
					["B_MBT_01_cannon_F", "B_MBT_01_TUSK_F"], // Veh 2 - Tank - Slammer, Slammer UP 
					["B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F"], // Veh 3 - Hunter
					["B_AFV_Wheeled_01_cannon_F", "B_AFV_Wheeled_01_up_cannon_F", "B_APC_Wheeled_03_cannon_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F"], // Veh 4 - APC - Rhino, Rhino MGS Up, Gorgon, Marshall, Panther 	
					["B_APC_Tracked_01_AA_F"], // Veh 5 - AA
					["B_Heli_Light_01_armed_F", "B_Heli_Attack_01_F"], // Veh 6 - Air
					["B_AFV_Wheeled_01_cannon_F", "B_AFV_Wheeled_01_up_cannon_F", "B_APC_Wheeled_03_cannon_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F"], // Veh 7 - APC - Rhino, Rhino MGS Up, Gorgon, Marshall, Panther 
					["B_MBT_01_cannon_F", "B_MBT_01_TUSK_F"], // Veh 8 - Tank				
					["B_MBT_01_cannon_F", "B_MBT_01_TUSK_F"] // Veh 9 - Tank					
				],
				[ // CSAT convoy
					["O_T_LSV_02_armed_F", "O_T_LSV_02_AT_F", "O_G_Offroad_01_armed_F"], // Veh 1 - Offroad					
					["O_MBT_02_cannon_F", "O_MBT_04_cannon_F", "O_MBT_04_command_F"], // Veh 2 - Tank		
					["O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F"], // Veh 3 - Ifrit
					["O_APC_Tracked_02_cannon_F", "O_APC_Wheeled_02_rcws_v2_F"], // Veh 4 - APC - Madrid, Kamysh 
					["O_APC_Tracked_02_AA_F"], // Veh 5	- AA
					["O_Heli_Light_02_F", "O_Heli_Attack_02_black_F"], // Veh 6- Air	
					["O_APC_Tracked_02_cannon_F", "O_APC_Wheeled_02_rcws_v2_F"], // Veh 7 - APC - Madrid, Kamysh 		
					["O_MBT_02_cannon_F", "O_MBT_04_cannon_F", "O_MBT_04_command_F"], // Veh 8 - Tank			
					["O_MBT_02_cannon_F", "O_MBT_04_cannon_F", "O_MBT_04_command_F"] // Veh 9 - Tank					
									
				],
				[ // AAF convoy
					["I_C_Offroad_02_LMG_F", "I_C_Offroad_02_AT_F",  "I_G_Offroad_01_armed_F"], // Veh 1 - Offroad
					["I_MBT_03_cannon_F"], // Veh 2 - Tank	
					["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F"], // Veh 3 - Strider
					["I_APC_Wheeled_03_cannon_F", "I_APC_tracked_03_cannon_F"], // Veh 4 - APC			
					["I_Heli_light_03_F"], // Veh 5 - Air
					["I_APC_Wheeled_03_cannon_F", "I_APC_tracked_03_cannon_F"], // Veh 6 - APC				
					["I_MBT_03_cannon_F"], // Veh 7 - Tank				
					["I_MBT_03_cannon_F"], // Veh 8- Tank
					["B_APC_Tracked_01_AA_F"] // Veh 9 - AA				
				]
			]
		]
	];

	_missionType = _mechPatrol select 0;
	_moneyAmount = _mechPatrol select 1;
	_convoys = _mechPatrol select 2;
	_vehChoices = selectRandom _convoys;

	_moneyText = format ["$%1", [_moneyAmount] call fn_numbersText];

	_vehClasses = [];
	{ _vehClasses pushBack selectRandom _x } forEach _vehChoices;
};

_setupObjects =
{
	private ["_starts", "_startDirs", "_waypoints"];

	_createVehicle =
	{
		private ["_type", "_position", "_direction", "_vehicle", "_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "FLY"];
		_vehicle setVariable ["R3F_LOG_disabled", true, true];
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

		sleep 1;
		
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
	
		[_vehicle, _aiGroup] spawn checkMissionVehicleLock;

		_vehicle
	};
	
	sleep 0.5;

//**************************************************************
    // TOWN SKIP AND PLAYER PROXIMITY CHECK

    _skippedTowns = // get the list from -> \mapConfig\towns.sqf
    [
        //"Town_14" // Pythos Island Marker Name
    ];

    _town = ""; _missionPos = [0,0,0]; _radius = 0;
    _townOK = false;
    while {!_townOK} do
    {
        _town = selectRandom (call cityList); // initially select a random town for the mission.
        _missionPos = markerPos (_town select 0); // the town position.
		_radius = (_town select 1); // the town radius.
		_anyPlayersAround = (nearestObjects [_missionPos,["MAN"],_radius]) select {isPlayer _x}; // search the area for players only.
		if (((count _anyPlayersAround) isEqualTo 0) && !((_town select 0) in _skippedTowns)) exitWith // if there are no players around and the town marker is not in the skip list, set _townOK to true (exit loop).
        {
            _townOK = true;
        };
        sleep 0.1; // sleep between loops.
    };
//*************************************************************

	_aiGroup = createGroup CIVILIAN;

	_vehicles = [];
	_vehiclePosArray = nil;
	{
		_vehiclePosArray = getPos ((_missionPos nearRoads _radius) select _forEachIndex);
		if (isNil "_vehiclePosArray") then
		{
			_vehiclePosArray = [_missionPos,(_radius / 2),_radius,5,0,0,0] call findSafePos;
		};
		_vehicles pushBack ([_x, _vehiclePosArray, 0, _aiGroup] call _createVehicle);
		_vehiclePosArray = nil;
	} forEach _vehClasses;

	_veh2 = _vehClasses select (1 min (count _vehClasses - 1));

	_leader = effectiveCommander (_vehicles select 0);
	_aiGroup selectLeader _leader;
	_leader setRank "LIEUTENANT";		
	_aiGroup setCombatMode "YELLOW"; // GREEN = Hold fire, Defend only; YELLOW = Fire at will;  RED = Fire at will, engage at will
	_aiGroup setBehaviour "SAFE"; // SAFE = Defend only; AWARE = (default) Take action when enemy is noted; COMBAT = Always alert
	_aiGroup setFormation "FILE"; //COLUMN - Line up single file behind unit 1; STAG COLUMN - Two columns offset, left column leads; FILE - Same as COLUMN, except tighter.

	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" }; //"LIMITED" (half speed); "NORMAL" (full speed, maintain formation); "FULL" (do not wait for any other units in formation)

	_aiGroup setSpeedMode _speedMode;

	sleep 0.5;
	
	{
		_waypoint = _aiGroup addWaypoint [markerPos (_x select 0), 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 25;
		_waypoint setWaypointCombatMode "YELLOW"; // GREEN = Hold fire, Defend only; YELLOW = Fire at will;  RED = Fire at will, engage at will
		_waypoint setWaypointBehaviour "SAFE"; // SAFE = Defend only; AWARE = (default) Take action when enemy is noted; COMBAT = Always alert
		_waypoint setWaypointFormation "FILE"; //COLUMN - Line up single file behind unit 1; STAG COLUMN - Two columns offset, left column leads; FILE - Same as COLUMN, except tighter.
		_waypoint setWaypointSpeed _speedMode;
	} forEach ((call cityList) call BIS_fnc_arrayShuffle);

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _veh2 >> "picture");
	_vehicleName = getText (configFile >> "cfgVehicles" >> _veh2 >> "displayName");

	_missionHintText = format ["A mechanized convoy transporting supplies and <t color='%3'>%1</t> escorted by a <t color='%3'>%2</t> is patrolling a section of the island.<br/>Stop them!", _moneyText, _vehicleName, PriorityMissionColor];

	_numWaypoints = count waypoints _aiGroup;
};

_waitUntilMarkerPos = {getPosATL _leader};
_waitUntilExec = nil;
_waitUntilCondition = {currentWaypoint _aiGroup >= _numWaypoints};

_failedExec = nil;

// _vehicles are automatically deleted or unlocked in missionProcessor depending on the outcome

// Mission completed

_successExec =
{
	for "_i" from 1 to 10 do
	{
		_cash = createVehicle ["Land_Money_F", _lastPos, [], 5, "None"];
		_cash setPos ([_lastPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_cash setDir random 360;
		_cash setVariable ["cmoney", _moneyAmount / 10, true];
		_cash setVariable ["owner", "world", true];
	};

switch (_missionType) do
	{
		case "Quick Attack":
		{
			_boxes1 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F", "Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
			_box1 = createVehicle [_boxes1, _lastPos, [], 5, "NONE"];
			_box1 setDir random 360;
			_box1 call randomCrateLoadOut; // Randomly fills box with equipment
			_box1 allowDamage false;
			
			//Crate Behavior	
					
			{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1];	//Allows crates to be picked up and carried

			//Smoke to mark the crates
			_smokemarker = createMarker ["SMMarker1", _lastPos];
			[_smokemarker] spawn CrateSmoke; //Calls repeating green smoke grenade
			uiSleep 2;		
			deleteMarker "SMMarker1"; 		
			
		};
		case "Light Mechanized":
		{
			_boxes1 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F", "Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
			_box1 = createVehicle [_boxes1, _lastPos, [], 5, "NONE"];
			_box1 setDir random 360;
			_box1 call randomCrateLoadOut; // Randomly fills box with equipment
			_box1 allowDamage false;

			_boxes2 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F", "Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
			_box2 = createVehicle [_boxes2, _lastPos, [], 5, "NONE"];
			_box2 setDir random 360;
			_box2 call randomCrateLoadOut; // Randomly fills box with equipment
			_box2 allowDamage false;
			
			//Crate Behavior	
					
			{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];	//Allows crates to be picked up and carried

			//Smoke to mark the crates
			_smokemarker = createMarker ["SMMarker1", _lastPos];
			[_smokemarker] spawn CrateSmoke; //Calls repeating green smoke grenade
			uiSleep 2;		
			deleteMarker "SMMarker1";
			
		};
		case "Medium Mechanized":
		{
			_boxes1 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F", "Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
			_box1 = createVehicle [_boxes1, _lastPos, [], 5, "NONE"];
			_box1 setDir random 360;
			_box1 call randomCrateLoadOut; // Randomly fills box with equipment
			_box1 allowDamage false;

			_boxes2 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F", "Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
			_box2 = createVehicle [_boxes2, _lastPos, [], 5, "NONE"];
			_box2 setDir random 360;
			_box2 call randomCrateLoadOut; // Randomly fills box with equipment
			_box2 allowDamage false;
			
			_box3 = createVehicle ["Box_NATO_WpsLaunch_F", _lastPos, [], 5, "None"];
			_box3 setDir random 360;
			[_box3, "airdrop_launchers"] call fn_refillbox; //Launcher box
			_box3 allowDamage false;
			
			//Crate Behavior	
					
			{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2, _box3];	//Allows crates to be picked up and carried

			//Smoke to mark the crates
			_smokemarker = createMarker ["SMMarker1", _lastPos];
			[_smokemarker] spawn CrateSmoke; //Calls repeating green smoke grenade
			uiSleep 2;		
			deleteMarker "SMMarker1";
			
		};
			case "Heavy Mechanized":
		{
			_boxes1 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F", "Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
			_box1 = createVehicle [_boxes1, _lastPos, [], 5, "NONE"];
			_box1 setDir random 360;
			_box1 call randomCrateLoadOut; // Randomly fills box with equipment
			_box1 allowDamage false;

			_boxes2 = selectRandom ["Box_NATO_Wps_F","Box_East_Wps_F","Box_IND_Wps_F", "Box_IND_Ammo_F","Box_IND_AmmoOrd_F","Box_IND_Grenades_F","Box_IND_Support_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
			_box2 = createVehicle [_boxes2, _lastPos, [], 5, "NONE"];
			_box2 setDir random 360;
			_box2 call randomCrateLoadOut; // Randomly fills box with equipment
			_box2 allowDamage false;

			_boxes3 = ["airdrop_weapons","airdrop_ordinance","airdrop_ammo","airdrop_supplies"] call BIS_fnc_selectRandom;
			_box3 = createVehicle ["Box_NATO_WpsSpecial_F", _lastPos, [], 5, "NONE"];
			_box3 setDir random 360;
			[_box3, _boxes3] call fn_refillbox; // Fills from set list associated with type of box	
			_box3 allowDamage false;
			
			_box4 = createVehicle ["Box_NATO_WpsLaunch_F", _lastPos, [], 5, "None"];
			_box4 setDir random 360;
			[_box4, "airdrop_launchers"] call fn_refillbox; //Launcher box
			_box4 allowDamage false;		

			_boxes5 = ["mission_USLaunchers","mission_USSpecial","mission_Main_A3snipers"] call BIS_fnc_selectRandom;
			_box5 = createVehicle ["Box_IND_Ammo_F", _lastPos, [], 5, "NONE"];
			_box5 setDir random 360;
			[_box5, _boxes5] call fn_refillbox; // Fills from set list associated with type of box	
			_box5 allowDamage false;

		//Crate Behavior	
					
			{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2, _box3,_box4, _box5];	//Allows crates to be picked up and carried

			//Smoke to mark the crates
			_smokemarker = createMarker ["SMMarker1", _lastPos];
			[_smokemarker] spawn CrateSmoke; //Calls repeating green smoke grenade
			uiSleep 2;		
			deleteMarker "SMMarker1";
			
		};	
	};		

		//Message
					
		_successHintMessage = "Great job! You've completed the mission! Rewards are nearby.";
		
};

_this call PriorityMissionProcessor;