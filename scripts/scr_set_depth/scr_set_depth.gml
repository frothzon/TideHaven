// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_set_depth(yy = bbox_bottom, _offset=0){
	static get_depth = function(_d){
		return -((_d - CAMERA.y) >> 1) - 100;
	}
	var _min = get_depth(CAMERA.y+CAMERA.h+sprite_height);
	var _max = get_depth(CAMERA.y);
	depth = clamp(get_depth(yy)+_offset, _min, _max);
}