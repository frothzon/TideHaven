// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_place_floor(item, bag){
	
	/// place object
	var obj = instance_create_depth(mouse_x, mouse_y, 0, obj_builder_floor);
	obj.sprite_index = item.sprite;
	obj.image_index = item.index;
	obj.item = item;
	obj.mode = 0;
	
	/// remove from bag
	scr_bag_add_item(bag, item, -1);
}

function scr_place_bridge(item, bag){
	var _bridge = instance_create_depth(mouse_x, mouse_y, 0, obj_builder_floor);
	_bridge.sprite_index = item.sprite;
	_bridge.image_index = item.index;
	_bridge.item = item;
	_bridge.mode = 0;
	_bridge.bridge_mode = true;
	_bridge.bridge_cell = -1;
	_bridge.bridge_tile_data = -1;
	scr_bag_add_item(bag, item, -1);
	return true;
}
