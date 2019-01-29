// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: sideMissionController.sqf
//	@file Author: AgentRev

#define MISSION_CTRL_PVAR_LIST TestMissions
#define MISSION_CTRL_TYPE_NAME "Test"
#define MISSION_CTRL_FOLDER "testMissions"
#define MISSION_CTRL_DELAY (["A3W_testMissionDelay", 15*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE testMissionColor

#include "testMissions\testMissionDefines.sqf"
#include "missionController.sqf";
