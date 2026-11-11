// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_setup_test_bag(){
	/*
		create a PLAYER_BAG to hold items, and a PLAYER_BAG for equipped PLAYER_GEAR
		
		PLAYER_BAG is a struct that contains 
			items: array of item structs
			amount: array of integer values keeping track of multiples of the same item
			resizable: whether the PLAYER_BAG grows to accomodate new items
	*/

	// setup items
	enum BAG{
		items,
		recipes,
		star,
		heart,
		settings,
		clock,
		leave
	}
	
	bag_list[BAG.items] = scr_bag_create(BAG_SLOT_AMT, "Items");	/// main bag
	bag_list[BAG.recipes] = scr_bag_create(BAG_SLOT_AMT, "Recipes");	/// recipe bag
	bag_index = 0;
	 
	PLAYER_BAG_CURRENT = bag_list[bag_index];
	PLAYER_BAG_ITEMS = bag_list[BAG.items];
	PLAYER_BAG_RECIPES = bag_list[BAG.recipes];

	/// PLAYER_GEAR slots
	PLAYER_GEAR = scr_bag_create(5);
	gear_cooldown = 0;

	// equipment enums for easy reference
	enum _GEAR_{
		boots,
		shield,
		helm,
		chest,
		weapon
	};
	enum _TOOL_{
		pickaxe,
		axe,
		shovel,
		sword
	};

	/*
		functions that are called when an equippable item is used
	*/

	equip_boots = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 0);
	equip_shield = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 1);
	equip_helm = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 2);
	equip_chest = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 3);
	equip_weapon = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 4);

	/// Core tools and provisions for a new save.
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_tool_class("Iron Pickaxe", spr_bag_items, 14, _TOOL_.pickaxe, equip_weapon, -1, 1, "damage"), 1, 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_tool_class("Iron Shovel", spr_bag_items, 26, _TOOL_.shovel, equip_weapon, -1, 1, "damage"), 1, 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_tool_class("Iron Axe", spr_bag_items, 2, _TOOL_.axe, equip_weapon, -1, 1, "damage"), 1, 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_item_class("Fishing Rod", spr_stick, 0, scr_use_fishing_rod, -1, "Use while facing water to fish"), 1, 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, MAT_POTION, 2, 1);
	
	scr_bag_add_item(PLAYER_BAG_RECIPES, RECIPE_FLOOR_GRASS, 1, 1);
	scr_bag_add_item(PLAYER_BAG_RECIPES, RECIPE_WALL_GRASS, 1, 1);
	scr_bag_add_item(PLAYER_BAG_RECIPES, RECIPE_FLOOR_SOIL, 1, 1);
	
	scr_bag_add_item(PLAYER_BAG_ITEMS, global.CONTROLLER.seed_carrot, 3, 1);
}