// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_take_damage(sound_id = snd_whack, dmg_override=-1){

		var dmg_base = obj_player.damage.value;
		var dmg_calc = 0;
			
		if(dmg_override > -1){
			dmg_base = dmg_override;	
		}
		
		for(var i = 0; i < array_length(damage_matrix); i++){
			var mux = damage_matrix[i] * other.damage_matrix[i] * dmg_base;
			dmg_calc = max(mux, dmg_calc);	
		}
		
		life.value -= dmg_calc;
		
		/// effect
		var scale_x = 1.5;
		var scale_y = 1;
		var size_max = 16;
		var ww = sprite_get_width(sprite_index);
		if(ww * scale_x - ww > size_max){
			scale_x = (ww+size_max) / ww;
		}
		scale_y = 1/scale_x;
			
		/// animate
		scale.x = scale_x;
		scale.y = scale_y;
		image_blend = c_red;
			
		/// sound
		if(dmg_calc == 0){
			scr_print("immune");	
		}
		
		if(sound_id >= 0){
			var snd = scr_play_sound(sound_id, 0,[x,y]);
			audio_sound_pitch(snd, random_range(0.8, 1.2));
		}
}
