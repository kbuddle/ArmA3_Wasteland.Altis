//*******************************************************************************************
//* This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com
//********************************************************************************************
//* @file Name: CrateSmoke.sqf
//* Drops smoke and flares to mark location of reward crates.
//*	@file Edit: 27/04/2018 by [509th] Coyote Rogue

if (!isServer) exitWith {};

private ["_pos", "_smoke", "_flare", "_time"];
_pos = getMarkerPos "SMMarker1";
_time = 5; //Minutes smoke will last

for "_i" from 1 to _time do {

  _smoke = "SmokeShellGreen" createVehicle _pos;
  _flare = "F_40mm_Green" createVehicle _pos;

  if( _i < _time ) then {

    sleep 60;
  };
};		
