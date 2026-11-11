/// @description draw self zaxis


if(state == 1){
	var dx = x + lengthdir_x(12, held_angle);
	var dy = y + lengthdir_y(12, held_angle) - 4;
	var len = obj_player.key_vector.length() > 0 ? 1 : 0;
	draw_sprite_ext(spr_throw, len, dx, dy, 1, 1, held_angle, c_white, 1);
	//draw_line_width_color(x,y,dx,dy,3,c_lime,c_lime);
}

draw_sprite_ext(sprite_index,image_index,x,y-zAxis.z,1,1,0,c_white,1);

if(in_range && state == 0 && zAxis.onGround()){
	scr_draw_text_outline(x-string_width("!")*0.5,bbox_top-16,"!",,c_lime);
}