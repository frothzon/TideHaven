/// @description burn

if(on_fire){
	repeat(5){
		var xx = irandom_range(bbox_left+4,bbox_right-4);
		var yy = y-24 + irandom(4);
		var part = PARTICLE_ENGINE.pFlame;
		burst_particle(part, xx, yy, 1, false);
	}
	
	if(!audio_is_playing(sound_playing)){
		sound_playing = scr_play_sound(snd_fire, 0, [x,y]);
	}
	
}



