/// @description draw

draw_self();
if(cooldown <= 5){
	arrow_scale = lerp(arrow_scale, 1, 0.25);
} else {
	arrow_scale = 0;	
}

if(arrow_scale > 0){
	var dx = lengthdir_x(4, image_angle);
	var dy = lengthdir_y(4, image_angle);
	draw_sprite_ext(spr_arrow, 0, x+dx, y+dy, arrow_scale, arrow_scale, image_angle, c_white, 1);	
}



