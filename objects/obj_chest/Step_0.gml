/// @description update

in_range = false;
has_key = false;
if(state == 0){
	var obj = instance_nearest(x,y,obj_player);
	if(scr_check_instance(obj)){
		in_range = point_in_circle(x,y,obj.x,obj.y,sprite_width * 0.8);
		var keyopen = mouse_check_button(mb_left) | keyboard_check(KEY_EQUIP);
		if(in_range){
			if(keyopen){
				var _itemIndex = scr_random_weighted(drop_item_weights);
				var _item = drop_item_list[_itemIndex];
				var _amt = drop_quantities[_itemIndex];
				scr_bag_add_item(PLAYER_BAG_ITEMS, _item, _amt);
				state = 1;
				image_speed = 1;
				/// play sound?
				scr_play_sound(snd_Win_Synth_06, false);
			}
		}
	}
} else if(state == 1){
	if(image_index >= image_number-1){
		state = 2;
		image_speed = 0;
		image_index = 0;
		sprite_index = spr_chest_opened;
	}
}


