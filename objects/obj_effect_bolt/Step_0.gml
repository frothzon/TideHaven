/// @description count down and then hit

/*
damage = 10;
target = obj_player;
state = 0;
timer = 20;
timer_max = timer;
target_pos = {x,y};
*/

x = target_pos.x;
y = target_pos.y;

if(state == 0){
	if(timer > 0){
		timer--;
	} else {
		state = 1;
		image_speed = 1;
		
		/// do damage
		var list = ds_list_create();
		var hit = collision_circle_list(target_pos.x, target_pos.y, range, target, 0, 1, list, 0);
		
		/// play sound
		scr_play_sound(snd_lightbolt1, 0);


		/// loop and damage
		for(var i = 0; i < hit; i++){
			var _targ = list[| i];
	
			/// instant damage to target
			if(variable_instance_exists(_targ, "life")){
				// damage to player
				var _hit = _targ.take_damage(damage);
				var _show = $"-{_hit}";
				if(_hit == -1){
					_show = "Blocked!";
					scr_show_text_float(_targ.x, _targ.bbox_top, _show, c_white);
				} else {
					scr_show_text_float(_targ.x, _targ.bbox_top, _show, c_red);
				}
			} else {
				// damage to another instance
				_targ.stats.life.add(-damage);
				scr_show_text_float(_targ.x, _targ.bbox_top, -damage, c_red);
				with(_targ){
					scr_switch_state(STATE_MON.hurt);
				}
			}
		}

		ds_list_destroy(list);
	}
} else {
	if(image_index >= image_number-1){
		instance_destroy();	
	}
}
