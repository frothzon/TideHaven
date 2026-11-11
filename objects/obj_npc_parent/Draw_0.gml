/// @description setup

draw_self();

if(in_range && state == 0){
	draw_set_halign(fa_center);
	var offset = scr_wave(-8, 0, 1, 0);
	draw_set_valign(fa_bottom);
	scr_draw_text_outline(x, y - sprite_height + offset, "?", c_black, c_yellow);
	scr_draw_reset();
}
