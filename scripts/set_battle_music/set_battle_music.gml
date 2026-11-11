// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_battle_music(music_default, music_battle, set_battle=true){
	if(set_battle){
		audio_sound_gain(music_default, 0, 5000);
		audio_sound_gain(music_battle, 1, 5000);
	} else {
		audio_sound_gain(music_default, 1, 5000);
		audio_sound_gain(music_battle, 0, 5000);
	}
}