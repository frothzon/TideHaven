// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_climb_animations(){
	if(key_vector.length() == 0){
		image_speed = 0;
		animator = [
			/// right
			char_climbing_down_anim,
			/// up
			char_climbing_up_anim,
			/// left
			char_climbing_up_anim,
			/// down
			char_climbing_down_anim
		];
	} else {
		image_speed = 1;
		animator = [
			/// right
			char_climbing_down_anim,
			/// up
			char_climbing_up_anim,
			/// left
			char_climbing_up_anim,
			/// down
			char_climbing_down_anim
		];
	}
}