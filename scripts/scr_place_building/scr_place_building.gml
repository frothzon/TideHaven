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