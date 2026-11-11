// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pick_tile_size(_str = "4x4"){
	var arr = string_split(_str, "x");
	var val = string_digits(arr[0]);
	return is_real(val) ? val : 16;
}