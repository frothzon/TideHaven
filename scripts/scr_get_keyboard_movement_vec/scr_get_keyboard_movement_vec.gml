// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_get_keyboard_movement_vec(vec2){
	var left = keyboard_check_direct(KEY_LEFT);
	var right = keyboard_check_direct(KEY_RIGHT);
	var up = keyboard_check_direct(KEY_UP);
	var down = keyboard_check_direct(KEY_DOWN);
	vec2.x = right - left;
	vec2.y = down - up;
	if(vec2.x != 0 && vec2.y != 0){
		vec2.x *= 0.707;	
		vec2.y *= 0.707;	
	}
	
	if(vec2.length() > 0){
		var move_spd = spd.value;
		if(is_climbing){
			move_spd *= 0.5;
		}
		if(mouse_check_button(mb_left)){
			move_spd *= 0.3;	
		}
		vec2.x *= move_spd;
		vec2.y *= move_spd;
	}
}