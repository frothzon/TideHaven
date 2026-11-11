/// @description draw

var margin = 4;
draw_sprite_stretched_ext(spr_wall_tileset, wall_index, x, y, sprite_width, sprite_height,wall_color,1);
draw_sprite_stretched_ext(spr_trim, 0, x, y, sprite_width, sprite_height,trim_color,1);
draw_sprite_stretched_ext(spr_roof, 0, x-margin, y-32, sprite_width+margin*2, sprite_height,image_blend,1);

