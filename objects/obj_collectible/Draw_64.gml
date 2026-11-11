/// @description Insert description here
// You can write your code in this editor



if(amount > 1){
	var text_pos = new scr_vec2_class(x, yoffset);
	scr_transform_coordinates(CAMERA, text_pos, 1);
	draw_set_font(fnt_default);
	draw_text_outline_sdf(fnt_default,text_pos.x,text_pos.y,"x" + string(amount),,c_lime);
	delete text_pos;
}

