// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_default_animations(){
	image_speed = 1;
	if(key_vector.length() == 0){
		animator = [
			/// right
			char_idle_right_anim,
			/// up
			char_idle_up_anim,
			/// left
			char_idle_left_anim,
			/// down
			char_idle_down_anim
		];
	} else {
		animator = [
			/// right
			char_run_right_anim,
			/// up
			char_run_up_anim,
			/// left
			char_run_left_anim,
			/// down
			char_run_down_anim
		];
	}
}