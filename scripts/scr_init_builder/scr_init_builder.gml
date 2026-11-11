// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_init_builder(){
	// Inherit the parent event
	event_inherited();

	image_speed = 0;
	item = BUILD_WALL_GRASS;
	image_index = item.index;
	mode = 1;

	timer = 5;
	is_safe = false;
	fade = 1;

	// hold position
	anchor = {
		x: 0,
		y: 0
	}
}