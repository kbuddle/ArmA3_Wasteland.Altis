/* Based on export from T-3DEN misison exporter
	Created by BUDDSKI
	Created 21.01.2019
*/

// DEFINITION AND POSITIONING OF WEAPONS
private _weapons = // Weapons as exported from editor inc. locations
[
	["I_HMG_01_high_F", ["", ""], [[6099.67,11854.7,91.8024],[[0.360903,0.932603,0],[0,0,1]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]],
	["I_HMG_01_high_F", ["", ""], [[6103.42,11849.8,91.8024],[[0.916257,0.400592,0],[0,0,1]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]],
	["I_HMG_01_high_F", ["", ""], [[6323.65,12109,156.864],[[-0.734604,-0.678496,0],[0,0,1]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]],
	["I_HMG_01_high_F", ["", ""], [[6327.54,12108.9,156.864],[[0.753112,-0.657892,0],[0,0,1]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]],
	["I_GMG_01_high_F", ["", ""], [[6360.55,12086.8,149.8],[[-0.907245,0.420603,0],[0,0,1]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]],
	["I_HMG_01_high_F", ["", ""], [[6362.08,12083.6,149.8],[[-0.905489,-0.42437,0],[0,0,1]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]],
	["I_HMG_01_high_F", ["", ""], [[6577,12281.4,178.002],[[0.984444,-0.148455,-0.0939771],[0.0566554,-0.238087,0.96959]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]],
	["I_HMG_01_high_F", ["", ""], [[6446.98,12410.8,204.643],[[0.748516,0.622225,-0.229261],[0.19234,0.127147,0.973056]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]],
	["I_GMG_01_high_F", ["", ""], [[6496.01,12185.5,159.571],[[0.965183,0.0436872,-0.257902],[0.257859,0.00670075,0.966159]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]],
	["I_HMG_01_high_F", ["", ""], [[6329.11,12351.2,203.579],[[-0.958841,-0.131385,-0.251719],[-0.246637,-0.0538809,0.967609]], 0], [1, 0, 1, 1], [false, true, false, false, true], [1, "true"], [[[[],[]],[[],[]],[[],[]],[[],[]]],false], [false, false, false, 0]]
];

// CREATING THE WEAPONS
{
	private _spawnedWeapons = [];
	private _obj = objNull;
	private _paramsPresenceV = _x select 5;

	if ((random(1) < (_paramsPresenceV select 0)) && call compileFinal(_paramsPresenceV select 1)) then
	{
		private _paramsPosV = _x select 2;

		private _posV = _paramsPosV select 0;
		private _randPosV = _paramsPosV select 2;

		_obj = (_x select 0) createVehicle _posV;

		_obj setPosWorld _posV;

		if !(_randPosV isEqualTo 0) then {
			private _randPosVX2 = _randPosV * 2;
			_posV = getPos _obj;
			_posV set [0, (_posV select 0) + ((random _randPosVX2) - _randPosV)];
			_posV set [1, (_posV select 1) + ((random _randPosVX2) - _randPosV)];
			_obj setPos _posV;
		};

		_obj setVectorDirAndUp (_paramsPosV select 1);

	};

	_spawnedWeapons set [_forEachIndex, _obj];

	/* _obj setDamage 0;
	_obj setVehicleAmmo 1;

	_obj enableDynamicSimulation false;
	_obj enableSimulationGlobal true;
	_obj hideObjectGlobal false;
	_obj allowDamage true; */

} forEach _weapons;

 /* // SETTING UP THE WEAPONS
{
	private _paramsInitV = _x select 1;
	private _paramsStatesV = _x select 3;
	private _paramsSpecStatesV = _x select 4;
	private _paramsGear = _x select 6;
	private _paramsElectr = _x select 7;

	_obj = _spawnedWeapons select _forEachIndex;

	_obj setVehicleVarName (_paramsInitV select 0);

	_obj lock (_paramsStatesV select 0);
	_obj setDamage [(_paramsStatesV select 1), false];
	_obj setFuel (_paramsStatesV select 2);
	_obj setVehicleAmmo (_paramsStatesV select 3);

	_obj enableDynamicSimulation (_paramsSpecStatesV select 0);
	_obj enableSimulationGlobal (_paramsSpecStatesV select 1);
	_obj hideObjectGlobal (_paramsSpecStatesV select 3);
	_obj allowDamage (_paramsSpecStatesV select 4);

	[_obj, _paramsGear] call BIS_fnc_initAmmoBox;

	_obj setVehicleReportRemoteTargets (_paramsElectr select 0);
	_obj setVehicleReceiveRemoteTargets (_paramsElectr select 1);
	_obj setVehicleReportOwnPosition (_paramsElectr select 2);
	_obj setVehicleRadar (_paramsElectr select 3);

	if !((_paramsInitV select 1) isEqualTo "") then
	{
		[_obj, (compileFinal (_paramsInitV select 1))] remoteExec ['bis_fnc_call', 0, _obj];
	};
} forEach (_weapons); */