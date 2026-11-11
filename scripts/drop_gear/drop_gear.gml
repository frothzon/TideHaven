// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// @func drop_gear(type, x, y);
/// @param {Real} type (_GEAR_)
/// @param {Real} x (drop x)
/// @param {Real} y (drop y)
/// @return {Bool} success
function drop_gear(type=irandom(3), xto, yto){
	var bag = instance_find(obj_player_bag, 0);
	if(!scr_check_instance(bag)){
		return 0;
	}
	
	var _data = make_gear(type);
	
	if(is_struct(_data)){
		var _item = instance_create_depth(xto, yto, 0, obj_collectible);
		_item.item = _data;
		_item.sprite_index = _data.sprite;
		_item.image_index = _data.index;
		return 1;
	}
	return 0;
	/*
	STAT_LEVEL
	
	enum _GEAR_{
		boots,
		shield,
		helm,
		chest
	};
	
	equip_boots = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 0);
	equip_shield = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 1);
	equip_helm = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 2);
	equip_chest = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 3);

	repeat(3){
		scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Worn Boots", spr_items_boots, 0, equip_boots, -1,random(0.1)+0.1,"speed"), 1);
	}
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Rusty Shield", spr_items_shield, 0, equip_shield, -1,1,"damage"), 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Iron Helm", spr_items_helm, 0, equip_helm, -1,2,"life"), 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Chest Plate", spr_items_chest, 0, equip_chest, -1,3,"life"), 1);
	*/
}

