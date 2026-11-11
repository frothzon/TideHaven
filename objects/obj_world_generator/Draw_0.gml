/// @description skip draw

if(variable_instance_exists(id, "dungeon_scene") && dungeon_scene){
	draw_set_color(make_color_rgb(13, 17, 23));
	draw_rectangle(x-512, y-176, x+512, y+176, false);
	draw_set_color(make_color_rgb(57, 64, 67));
	draw_rectangle(x-464, y-112, x-224, y+80, false);
	draw_rectangle(x-224, y-48, x+224, y+16, false);
	draw_rectangle(x+224, y-112, x+464, y+80, false);
	draw_set_color(make_color_rgb(72, 78, 78));
	for(var _xx = x-448; _xx < x+448; _xx += 32){
		for(var _yy = y-96; _yy < y+64; _yy += 32){
			if((_xx < x-224 || _xx >= x+224) || (_yy >= y-48 && _yy < y+16)){
				draw_rectangle(_xx, _yy, _xx+1, _yy+1, false);
			}
		}
	}
	draw_set_color(make_color_rgb(115, 102, 74));
	draw_circle_color(x+384, y, 24, make_color_rgb(164, 133, 77), make_color_rgb(63, 57, 44), false);
	scr_draw_reset();
	exit;
}

exit;
