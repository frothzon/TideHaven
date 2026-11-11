/// @description draw effect

/*
damage = 10;
target = obj_player;
state = 0;
timer = 20;
timer_max = timer; 
range = 16;
image_speed = 0;
image_index = 0;
*/

if(state == 0){
	var ratio = (timer_max - timer)	/ timer_max;
	draw_set_alpha(ratio);
	gpu_set_blendmode(bm_add);
	draw_circle_color(x, y, range+5, c_black, c_red, 0);
	gpu_set_blendmode(bm_normal);
	draw_circle_color(x, y, range+5, c_black, c_red, 1);
	draw_set_alpha(1);
} else {
	draw_self();	
}