// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function random_gear_name(gearType){

	var adjectives = ["Ancient", "Mystical", "Enchanted", "Grimy", "Legendary", "Cursed", "Forgotten", "Arcane", "Mighty", "Dreaded", "Rotten", "Broken", "Putrid",
		"Echoing","Whispering","Crowned","Veiled","Legendary","Oathed","Chained","","","Blessed","Heavenly"
	];
	var titles = ["of Gilgamesh", "of Eternal Power", "of the Dragon", "of Shadows", "of the Phoenix", "of Gore", "of the Ancients", "of Thunder", "of the Mystic Warrior", "of Infinite Trials",
		"of the Forgotten Age", "of the Shadow Realm", "of the Fallen Star", "of the Sun", "of the Moon", "of the Eclipse", "of the Crystal Void", "of the Guardian", "of the Abyss", "of the Heart", 
		"Forged in Hellfire","Forged in blood","Forged in Chaos"
	];

	// Generate a random index for adjectives and titles
	var adjIndex = floor(random(1) * array_length(adjectives));
	var titleIndex = floor(random(1) * array_length(titles));

	// Combine the parts to create a gear name
	return $"{adjectives[adjIndex]} {gearType} {titles[titleIndex]}";
}