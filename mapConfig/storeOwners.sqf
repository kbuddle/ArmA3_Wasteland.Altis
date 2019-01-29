// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: storeOwners.sqf
//	@file Author: AgentRev, JoSchaap, His_Shadow

// Notes: Gun and general stores have position of spawned crate, vehicle stores have an extra air spawn direction
//
// Array contents are as follows:
// Name, Building Position, Desk Direction (or [Desk Direction, Front Offset]), Excluded Buttons
storeOwnerConfig = compileFinal str
[
	["GenStore1", 6, 240, []], //South Central Island
	["GenStore2", 6, 250, []], //Selakano
	["GenStore3", 6, 45, []], //Charkia
	["GenStore4", 0, 265, []], //Agios Dionysus
	["GenStore5", 5, 350, []], //Oreokastro
	["GenStore6", 4, 270, []], //Molos
	["GenStore7", 3, 140, []], //Panachori

	["GunStore1", 1, 0, []], //Kavala
	["GunStore2", 1, 75, []], //Pyrgos
	["GunStore3", 6, 135, []], //Sofia
	["GunStore4", 1, 65, []], //Abdera
	["GunStore5", 1, 120, []], //Selakano
	["GunStore6", 3, 90, []], //South Central Island

	// Buttons you can disable: "Land", "Armored", "Tanks", "Helicopters", "Boats", "Planes"
	["VehStore1", 1, 75, []], //Molos
	["VehStore2", 6, 45, ["Boats"]], //Saltflats
	["VehStore3", 4, 250, ["Boats"]], //Selakano
	["VehStore4", 5, 155, ["Boats"]], //Main airfield
	["VehStore5", 0, 190, ["Planes"]], //West coast
	["VehStore6", 1, 160, ["Boats", "Planes"]], //Pyrgos
	["VehStore7", 0, 60, []] //AAC
];

// Outfits for store owners
storeOwnerConfigAppearance = compileFinal str
[
	["GenStore1", [["weapon", ""], ["uniform", "U_IG_Guerilla2_2"]]],
	["GenStore2", [["weapon", ""], ["uniform", "U_IG_Guerilla2_3"]]],
	["GenStore3", [["weapon", ""], ["uniform", "U_IG_Guerilla3_1"]]],
	["GenStore4", [["weapon", ""], ["uniform", "U_IG_Guerilla2_1"]]],
	["GenStore5", [["weapon", ""], ["uniform", "U_IG_Guerilla3_2"]]],

	["GunStore1", [["weapon", ""], ["uniform", "U_B_SpecopsUniform_sgg"]]],
	["GunStore2", [["weapon", ""], ["uniform", "U_O_SpecopsUniform_blk"]]],
	["GunStore3", [["weapon", ""], ["uniform", "U_I_CombatUniform_tshirt"]]],
	["GunStore4", [["weapon", ""], ["uniform", "U_IG_Guerilla1_1"]]],

	["VehStore1", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore2", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore3", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore4", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore5", [["weapon", ""], ["uniform", "U_Competitor"]]]
];
