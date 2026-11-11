/// @description draw name

var text_pos = new scr_vec2_class(x,bbox_bottom);

scr_transform_coordinates(CAMERA, text_pos, 1);

draw_set_halign(fa_middle);
draw_set_valign(fa_top);
draw_set_font(fnt_hud_small);
scr_draw_text_outline(text_pos.x,text_pos.y, name);

delete text_pos;