/// @description keep music playing

if(!audio_is_playing(music_playing)){
	
	/// reshuffle
	if(array_length(music_playlist) < 1){
		music_list = [mus_adventure1, mus_adventure2, mus_adventure3, mus_adventure4];
		music_playlist = array_shuffle(music_list);
	}
	music_playing = scr_play_music(array_pop(music_playlist), 0);
}