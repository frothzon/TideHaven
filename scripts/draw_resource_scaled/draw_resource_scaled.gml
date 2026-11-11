// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_resource_scaled(draw_fcn){
	image_xscale = scale.x;
	image_yscale = scale.y;
	draw_fcn();
	image_xscale = 1;
	image_yscale = 1;
}