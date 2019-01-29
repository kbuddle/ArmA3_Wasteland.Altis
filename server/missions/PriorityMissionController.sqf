// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: PriorityMissionController.sqf
//	@file Author: AgentRev

#define MISSION_CTRL_PVAR_LIST PriorityMissions
#define MISSION_CTRL_TYPE_NAME "Priority"
#define MISSION_CTRL_FOLDER "PriorityMissions"
#define MISSION_CTRL_DELAY (["A3W_PriorityMissionDelay", 30*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE PriorityMissionColor

#include "PriorityMissions\PriorityMissionDefines.sqf"
#include "missionController.sqf";
