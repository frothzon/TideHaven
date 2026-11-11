/// @description check for collision

scr_set_depth();

if(state == 0){
	var hit = collision_line(xprevious, yprevious, x, y, obj_wall, 1, 0);
	if(scr_check_instance(hit)){
		if(variable_instance_exists(hit, "life")){
			with(hit){
				scr_take_damage(snd_hit_wood);
			}
		} else {
			/// sound
			var snd = scr_play_sound(snd_whack, 0, [x,y]);
			audio_sound_pitch(snd, random_range(0.8, 1.2));
		}
		state = 1;
	}

	if(point_distance(xstart, ystart, x, y) > 1000){
		state = 1;
	}
} else {
	speed = 0;
	image_alpha = lerp(image_alpha, 0, 0.1);
	if(image_alpha <= 0){
		instance_destroy();	
	}
}




