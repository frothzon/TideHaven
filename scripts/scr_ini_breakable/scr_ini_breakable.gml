// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ini_breakable(){
	scr_setup_statvars(60, 0, 0);
	scaling = new scr_vec2_class(0.1,0.1);
	exp_given = 3;
	destroy_sound = snd_destroy;
	scr_ini_zAxis();
}

function scr_stp_breakable(yd = bbox_bottom){
	if(life.value <= 0){
		/// destroy object with stats
		if(variable_instance_exists(id, "stats")){
			if(scr_get_state_index() != 5){
				scr_switch_state(5);
				show_debug_message("death animation");
			}
		} else {
			/// normal destroy
			instance_destroy();	
		}
	}

	var _offset = (x div sprite_width) % 5;
	scr_set_depth(yd, _offset);

	/// return to normal
	scaling.x = lerp(scaling.x, 1, 0.2);
	scaling.y = lerp(scaling.y, 1, 0.2);
	image_blend = merge_color(image_blend, c_white, 0.2);
	zAxis.update();
}

function scr_destroy_breakable(){
	scr_play_sound(destroy_sound, 0);
	var val = exp_given * EXP_MULT;
	STAT_EXP.value += val;
	scr_show_text_float(x,y,scr_concat(val, " Exp"), c_lime);
	/// spawn later
	var _spawner = instance_create_depth(x,y,0,obj_respawn);
	_spawner.spawn = object_index;
}