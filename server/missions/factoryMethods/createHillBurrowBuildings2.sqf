// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: createHellHill1.sqf
//	@file Author: BUDDSKI
//	@file Created: 30/12/2018
//Construct Hill Burrow Hell Mission buildings - compiled from editor output using T3DEN sqf exporter


	{
	private _paramsPresence = _x select 5;

	if ((random(1) < (_paramsPresence select 0)) && call compileFinal(_paramsPresence select 1)) then {
		private _paramsInit = _x select 1;
		private _paramsPos = _x select 2;
		private _paramsStates = _x select 3;
		private _paramsSpecStates = _x select 4;
		private _pos = _paramsPos select 0;
		private _randPos = _paramsPos select 2;

		private _obj = (_x select 0) createVehicle _pos;
		_obj setPosWorld _pos;

		if !(_randPos isEqualTo 0) then {
			private _randPosX2 = _randPos * 2;
			_pos = getPos _obj;
			_pos set [0, (_pos select 0) + ((random _randPosX2) - _randPos)];
			_pos set [1, (_pos select 1) + ((random _randPosX2) - _randPos)];
			_obj setPos _pos;
		};

		_obj setVectorDirAndUp (_paramsPos select 1);

		_obj setVehicleVarName (_paramsInit select 0);

		_obj enableDynamicSimulation (_paramsSpecStates select 0);
		_obj enableSimulationGlobal (_paramsSpecStates select 1);
		_obj hideObjectGlobal (_paramsSpecStates select 2);
		_obj allowDamage (_paramsSpecStates select 3);

		_obj setDamage [(_paramsStates select 0), false];
		_obj setVehicleAmmo (_paramsStates select 1);

		if !((_paramsInit select 1) isEqualTo "") then {
			[_obj, (compileFinal (_paramsInit select 1))] remoteExec ['bis_fnc_call', 0, _obj];
		};

		};
	} forEach [
		["Land_Bunker_01_small_F", ["Lookout3", ""], [[6362.08,12086.3,147.932], [[0.814683,0.579907,0], [0,0,1]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		//,["Box_NATO_Equip_F", ["", ""], [[6435.66,12159.9,161.142], [[0.285686,0.955784,0.0697229], [-0.126368,-0.034548,0.991382]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		//,["Box_T_East_Wps_F", ["", ""], [[6434.09,12159.3,160.884], [[-0.324267,0.945966,0], [0,0,1]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		,["APERSTripMine", ["", ""], [[6434.92,12163.8,160.695], [[-0,-1,-0], [0,0,1]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		,["Land_Bunker_01_HQ_F", ["BunkerHQ", ""], [[6433.35,12164.2,161.681], [[0.999056,-0.0434449,0], [0,0,1]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		,["Land_Bunker_01_big_F", ["Lookout1", ""], [[6096.17,11848.7,90.1232], [[-0.821826,-0.569739,0], [0,0,1]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		,["Land_Bunker_01_small_F", ["Lookout2", ""], [[6325.44,12110.4,154.997], [[0,1,0], [0,0,1]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		,["Land_BagBunker_Small_F", ["Bunker3", ""], [[6576.29,12281.5,177.405], [[-0.974037,-0.153556,0.166349], [0.186627,-0.128709,0.973963]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		,["Land_BagBunker_Small_F", ["Bunker2", ""], [[6446.58,12410.7,204.021], [[-0.738576,-0.618038,0.269321], [0.231579,0.142599,0.962308]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		,["Land_BagBunker_Small_F", ["Bunker4", ""], [[6495.52,12185.8,158.939], [[-0.985254,-0.001447,0.171095], [0.171001,0.025843,0.984932]], 0], [0, 1], [false, true, false, true], [1, "true"]]
		,["Land_BagBunker_Small_F", ["Bunker1", ""], [[6329.13,12351.4,202.849], [[0.970218,0.0901116,0.224849], [-0.223522,-0.0246813,0.974386]], 0], [0, 1], [false, true, false, true], [1, "true"]]
	];
// _objs