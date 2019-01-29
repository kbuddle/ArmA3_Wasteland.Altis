// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: assaultMissionController.sqf

#define MISSION_CTRL_PVAR_LIST AssaultMissions
#define MISSION_CTRL_TYPE_NAME "Assault"
#define MISSION_CTRL_FOLDER "assaultMissions"
#define MISSION_CTRL_DELAY (["A3W_AssaultMissionDelay", 15*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE assaultMissionColor

#include "assaultMissions\assaultMissionDefines.sqf"
#include "missionController.sqf";
