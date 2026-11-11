/// @description draw self


if(length > 4){
	//draw_line_width_color(x, y, hook.x, hook.y, 3, c_dkgray, c_dkgray);
	//draw_line_width_color(x, y, hook.x, hook.y, 1, c_ltgray, c_ltgray);
	var ww = length/24;
	var dir = point_direction(x,y,hook.x,hook.y);
	draw_sprite_ext(spr_line, 0, x, y, ww, 1, dir, c_white, 1);
}
draw_sprite_ext(spr_grapple, 1, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
draw_sprite_ext(spr_grapple, 2, hook.x, hook.y, image_xscale, image_yscale, image_angle, c_white, 1);






