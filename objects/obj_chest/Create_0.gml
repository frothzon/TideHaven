/// @description setup

in_range = false;
state = 0;
image_speed = 0;
/// Add a small, real loot table once the player bag is ready.
var _bag = instance_find(obj_player_bag, 0);
if(scr_check_instance(_bag)){
	var _axe = new scr_tool_class("Iron Axe", spr_bag_items, 2, _TOOL_.axe, _bag.equip_weapon, -1, 1, "damage");
	var _sword = new scr_tool_class("Wooden Sword", spr_bag_items, 0, _TOOL_.sword, _bag.equip_weapon, -1, 1, "damage");
	drop_item_list = [MAT_FISH, MAT_POTION, _axe, _sword, make_gear()];
	drop_item_weights = [4, 10, 4, 5, 1];
	drop_quantities = [1, 1, 1, 1, 1];
}
