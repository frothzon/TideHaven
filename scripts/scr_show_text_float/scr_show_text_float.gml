// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_show_text_float(xto, yto, txt, col){
	var obj = instance_create_depth(xto, yto, 0, obj_text_float);
	obj.text = txt;
	obj.image_blend = col;
}