// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_draw_shadow(){
	var sy = image_yscale;
	var aa = image_alpha;
	var bl = image_blend;
	
	image_alpha = 0.5;
	image_yscale *= 0.5;
	image_blend = c_black;
	
	draw_self();
	
	image_alpha = aa;
	image_yscale = sy;
	image_blend = bl;
}