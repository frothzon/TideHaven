/// @description move to mouse for placement

scr_set_depth(CAMERA.y+CAMERA.h);
if(keyboard_check_pressed(vk_escape)){
	GAME_PAUSED = false;
	instance_destroy();	
	exit;
}

var xx = (((mouse_x) >> 4) << 4) + 8;
var yy = (((mouse_y-16) >> 4) << 4) + 16;

var find = instance_position(xx,yy,obj_builder_soil);
var can_plant = false;

if(scr_check_instance(find)){
	if(find.can_plant){
		can_plant = true;	
		show_debug_message(can_plant);
	}
}

scr_update_builder(obj_builder_soil, true, false, true, !can_plant);


/*
	_planter.item = item;
	_planter.bag = bag;
	_planter.mode = 0;
	_planter.plant = item.data;
	 scr_bag_get_amount(bag, find);
	 scr_bag_add_item(bag, drop, 1);
*/

var item_ind = scr_bag_search(bag, item);
var seeds_left = scr_bag_get_amount(bag, item_ind);
if(seeds_left <= 0){
	GAME_PAUSED = false;
	instance_destroy();	
}

if(mode == 1){
	if(can_plant){
		
		// remove item from bag
		find.plant = copy_new_plant(plant);
		//find.item = plant.drop;
		mode = 0;
		scr_bag_add_item(bag, item, -1);
	}
}