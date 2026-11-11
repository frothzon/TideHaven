/// @description update

in_range = false;
has_key = false;
if(state == 0){
	var obj = instance_nearest(x,y,obj_player);
	if(scr_check_instance(obj)){
		in_range = point_in_circle(x,y,obj.x,obj.y,sprite_width * 0.8);
		var keyin = mouse_check_button(mb_left) | keyboard_check(KEY_EQUIP);
		if(in_range){
			has_key = scr_bag_search(PLAYER_BAG_ITEMS, key_to_unlock);
			if(keyin && has_key){
				scr_bag_add_item(PLAYER_BAG_ITEMS, key_to_unlock, -1);
				state = 1;
				image_speed = 1;
				/// play sound?
				scr_play_sound(snd_lock_open, false);
			}
		}
	}
} else if(state == 1){
	if(image_index >= image_number-1){
		state = 2;
		scr_play_sound(snd_unlock, false);
		instance_destroy();
	}
}


