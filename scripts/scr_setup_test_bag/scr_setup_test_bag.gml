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

	repeat(3){
		scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Worn Boots", spr_items_boots, 0, equip_boots, -1,random(0.1)+0.1,"speed"), 1, 1);
	}
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Rusty Shield", spr_items_shield, 0, equip_shield, -1,1,"damage"), 1, 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Iron Helm", spr_items_helm, 0, equip_helm, -1,2,"life"), 1, 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Chest Plate", spr_items_chest, 0, equip_chest, -1,3,"life"), 1, 1);
	
	/// add pickaxe to bag
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_tool_class("Iron Pickaxe", spr_gear, 5, _TOOL_.pickaxe, equip_weapon, -1, 1, "damage"), 1, 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_tool_class("Iron Shovel", spr_gear, 0, _TOOL_.shovel, equip_weapon, -1, 1, "damage"), 1, 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_tool_class("Iron Axe", spr_gear, 15, _TOOL_.axe, equip_weapon, -1, 1, "damage"), 1, 1);
	
	
	scr_bag_add_item(PLAYER_BAG_RECIPES, RECIPE_FLOOR_GRASS, 1, 1);
	show_debug_message(RECIPE_FLOOR_GRASS);
	scr_bag_add_item(PLAYER_BAG_RECIPES, RECIPE_WALL_GRASS, 1, 1);
	show_debug_message(RECIPE_WALL_GRASS);
	scr_bag_add_item(PLAYER_BAG_RECIPES, RECIPE_FLOOR_SOIL, 1, 1);
	show_debug_message(RECIPE_FLOOR_SOIL);
	
	scr_bag_add_item(PLAYER_BAG_ITEMS, global.CONTROLLER.seed_carrot, 10, 1);
}