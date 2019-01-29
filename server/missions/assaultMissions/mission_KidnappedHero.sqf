// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_KidnappedHero.sqf
//	@file Author: Buddski
// building type "Land_i_Barracks_V2_F" - locations read from map for these buildings
// positions within buildings also read by code

if (!isServer) exitwith {};
#include "assaultMissionDefines.sqf"


private ["_barracks", "_barracksLocations", "_prisonerPosLocations", "_nbUnits", "_fillEvenly", "_putOnRoof", "_startTime"];
private ["_maxTime", "_missionPos", "_building", "_building2", "_prisonerPos", "_prisoner", "_bed", "_obj1", "_obj3", "_obj4"];
private ["_aiGroup", "_vehicleName", "_missionHintText", "_units", "_staticWeapons", "_unit"];
private ["_failedHintMessage", "_successExec", "_elapsedTime", "_killTeam"];
private ["_moneyAmount", "_newMoneyAmount", "_bonus", "_successHintMessage", "_missionMarker", "_missionPos0", "_missionPos1"];
_moneyAmount = Tier_2_Reward; //Reward amount for completing mission
// diag_log format ["PRISONER - routine commenced"]; //works
_setupVars =
{
	_missionType = "Kidnapped Hero";
	_barracksLocations = 
	[
 		["Barracks01",[3264.61,12466.6,1.11548]],
		["Barracks02",[3657.4,13191.7,0.680398]],
		["Barracks03",[4019.22,12540.3,0.610455]],
		["Barracks04",[4188.96,12817.8,0.97687]],
		["Barracks05",[4566.48,15421.7,0.923828]],
		["Barracks06",[6044.76,16231,1.28722]],
		["Barracks07",[6204.42,16223,1.29019]],
		["Barracks08",[7912.92,16154.3,0.824348]],
		["Barracks09",[9274.06,12150.5,0.736227]],
		["Barracks10",[11325.7,14153.6,0.881546]],
		["Barracks11",[11478.6,11801.4,1.04709]],
		["Barracks12",[11496,11828.9,0.827478]],
		["Barracks13",[11631,11889.2,1.11374]],
		["Barracks14",[12648,16412.3,1.11425]],
		["Barracks15",[12670.4,14778.5,0.673956]],
		["Barracks16",[13123.1,16352.7,0.845444]],
		["Barracks17",[14486.9,16337,0.83987]], //main airport
		["Barracks18",[14900.9,17160.1,1.09052]],
		["Barracks19",[15232.6,17441.4,0.828274]],
		["Barracks20",[15350.5,17432.6,0.720154]],
		["Barracks21",[15331.6,17450.1,0.673567]],
		["Barracks22",[15369.2,17414.4,0.82337]],
		["Barracks23",[15559.8,17440.5,0.746491]],
		["Barracks24",[16699,12789.5,0.901918]],
		["Barracks25",[16974.3,12865.2,0.953825]],
		["Barracks26",[17008.7,12809.4,0.68046]],
		["Barracks27",[17178.5,13303.6,1.31122]],
		["Barracks28",[18391,15251.3,1.00703]],
		["Barracks29",[18366,15484.7,0.743267]],
		["Barracks30",[18403.9,15278.9,1.08541]]
	];
	_prisonerPosLocations 	= [8,13,16,20,22,27,49 ];
	_nbUnits 				= floor (round (random 10) + 15);
	_fillEvenly 			= false;
	_putOnRoof 				= true;
	_startTime 				= diag_tickTime;
	_maxTime 				= A3W_AssaultMissionTimeout;
	_barracks		= [];
	_prisonerPos 	= [];
	_missionPos		= [];
	_building 		= [];
	_prisonerPos 	= selectRandom _prisonerPosLocations; //works
	_barracks 		= selectRandom _barracksLocations; //works
	_missionPos = _barracks select 1; 
};
_setupObjects =
{	
	//place prisoner in a specific room ,selected at random from planned positions
	_prisoner = createVehicle ["C_man_hunter_1_F", _missionPos, [], 0, "CAN_COLLIDE"];

	_prisoner setPos ( nearestBuilding _missionPos buildingPos _prisonerPos);
	waitUntil {alive _prisoner};

	[_prisoner, "Acts_AidlPsitMstpSsurWnonDnon_loop"] call switchMoveGlobal;
	_prisoner disableAI "anim";
	
	_bed = createVehicle ["Land_Stretcher_01_F", _missionPos, [], 0, "CAN_COLLIDE"];
	_bed setPos ( nearestBuilding _bed buildingPos _prisonerPos);

	//create the guns
	_obj1 = createVehicle ["I_HMG_01_high_F", _missionPos,[], 10,"NONE"];
	_obj1 setPos ( nearestBuilding _obj1 buildingPos 39);

	_obj3 = createVehicle ["I_HMG_01_high_F", _missionPos,[], 10,"NONE"];
	_obj3 setPos ( nearestBuilding _obj3 buildingPos 34);

	_obj4 = createVehicle ["I_HMG_01_high_F", _missionPos,[], 10,"NONE"];
	_obj4 setPos ( nearestBuilding _obj4 buildingPos 46);

	_aiGroup = createGroup CIVILIAN;
	
	[_aiGroup,_missionPos,_nbUnits,20] call createCustomGroup7;

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "AWARE";
		
	_killTeam =  count (units _aiGroup);

	[_aiGroup, _missionPos, 50, _fillEvenly, _putOnRoof] call moveIntoBuildings;
	diag_log format ["KIDNAPPED - below is prisoner info"];
	diag_log _prisoner;

	_vehicleName = "Prisoner";
	_missionHintText = format ["<t color='%3'>%4</t> bloody bastards have made your favourite TV personality a <t color='%3'>%2</t> and are threatening to <t color='%3'>KILL</t>your hero. <br/> Get in fast and you could double your get a fat bonus, but minimum reward is<t color='%3'>%1</t>.", _moneyAmount,_vehicleName, assaultMissionColor, _killTeam];
	uisleep 5;
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = {!alive _prisoner};

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_obj1, _obj3, _obj4, _prisoner, _bed];
	_failedHintMessage = format ["It is a sad day for you. Your hero is dead!"];
	sleep 5;
};

	// Mission completed
	_successExec =
	{
		// bonus for completing quickly ie max 200% $ at 50% maximum time
	 	_elapsedTime = diag_tickTime - _startTime;
		if (_elapsedTime > _maxTime/2) then 
		{
			_bonus = _moneyAmount * (_elapsedTime - (_maxTime/2))/(_maxTime/2);
			_newMoneyAmount = _moneyAmount + _bonus;
		} else {_newMoneyAmount = 2 * _moneyAmount};

		diag_log format["KIDNAPPED - MoneyCalcs _startTime %1, _elapsedTime %2, _maxTime %3", _startTime, _elapsedTime, _maxTime];
		diag_log format["KIDNAPPED - _moneyAmount %1, _bonus %2, newMoneyAmount %3 cashPile %4", _moneyAmount, _bonus, _newMoneyAmount, (_newMoneyAmount/10) ];

		//Money
		for "_i" from 1 to 10 do
		{
			_cash = createVehicle ["Land_Money_F", _missionPos, [], 5, "NONE"];
			_cash setPos ([_missionPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
			_cash setDir random 360;
			_cash setVariable ["cmoney", _newMoneyAmount / 10, true];
			_cash setVariable ["owner", "world", true];
		};
		
		//Message
		_successHintMessage = "Well done! Your TV hero lives to screen again.<br/>They are happy to see you earn your cash, but giving a signature is too hard. <br/>As soon as you killed the captors they just pissed off quick. <br/>Find your cash.";
		{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_obj1, _obj3, _obj4];
		{ deleteVehicle _x } forEach [_prisoner];
	};

_this call AssaultMissionProcessor;
