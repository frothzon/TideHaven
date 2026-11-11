// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_use_seed(item, bag){
	/*
	data = {
		items: _itemList, 
		amount: _qtyList,
		drop: _dropItem
	};
	*/
	/// check if it can be made
	var _planter = instance_create_depth(mouse_x, mouse_y, 0, obj_builder_plant);
	/*
		item = BUILD_WALL_GRASS;
		mode = 1;
		plant = scr_build_plant_data(null_name);
		bag = -1;
	*/
	_planter.item = item;
	_planter.bag = bag; 
	_planter.mode = 0;
	_planter.plant = item.data;
	_planter.sprite_index = item.data.sprite;
	
	/// play sound
	scr_play_sound(snd_use, 0);
}