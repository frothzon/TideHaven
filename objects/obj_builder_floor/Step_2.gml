/// @description add item to bag

if(life.value <= 0){
	if(variable_instance_exists(id, "bridge_mode") && bridge_mode) scr_restore_bridge_tile(id);
	if(is_struct(item)){
		scr_bag_add_item(PLAYER_BAG_ITEMS, item, 1);
		scr_play_sound(snd_collect, 0);
		instance_destroy();
	} else {
		life.value = life.max_value;	
	}
}

scr_set_depth(bbox_top-16);

/// return to normal
scaling.x = lerp(scaling.x, 1, 0.2);
scaling.y = lerp(scaling.y, 1, 0.2);
image_blend = merge_color(image_blend, c_white, 0.2);
