// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_update_builder(collide_obj, req_collision, player_can_block, isfloor=0, override=undefined){
	if(mode == 0){
		if(GAME_PAUSED == false) GAME_PAUSED = true;
		x = (((mouse_x) >> 4) << 4) + 8;
		y = (((mouse_y) >> 4) << 4) + 16;
		is_safe = true;
	
		var xmid = (bbox_left + bbox_right)*0.5;
		var ymid = (bbox_top + bbox_bottom)*0.5;
	
		var collide = req_collision ? true : false;
	
		if(collide_obj >= 0){
			if(collision_point(xmid, ymid, collide_obj, 0, 1) != noone){
				collide = req_collision ? false : true;
			}
		}
		if(player_can_block){
			if(collision_rectangle(xmid-8,ymid-8,xmid+8,ymid+8,obj_player,0,1) != noone){
				collide = true;
			}
		}

		// can collide with floor if is floor
		if(isfloor && collision_point(xmid, ymid, obj_floor_parent, 0, 1) != noone){
			collide = true;
		}
		
		// custom check
		if(override != undefined){
			collide = override;	
		}
	
		if(!scr_tile_at_position(xmid,ymid,"lay_sand") || collide){
			is_safe = false;	
		}
	
	
		if(mouse_check_button_released(mb_left) && is_safe && timer <= 0){
			mouse_clear(mb_left);
			GAME_PAUSED = false;
			mode = 1;
			anchor.x = x;
			anchor.y = y;
			/// play sound
			scr_play_sound(snd_placement, 0);
		}
		/// cancel
		if(keyboard_check_pressed(vk_escape)){
			GAME_PAUSED = false;
			mode = 1;
			life.value = 0;	
		}
	} else {
		x = anchor.x;
		y = anchor.y;
		if(fade > 0) fade -= 0.1;
	}


	if(timer > 0) timer--;
}