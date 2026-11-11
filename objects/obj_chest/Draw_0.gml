/// @description setup

draw_self();

if(in_range){
	draw_set_halign(fa_center);
	var offset = scr_wave(-12, -4, 1, 0);
	scr_draw_text_outline(x, bbox_top + offset, "!", c_black, c_yellow);
	scr_draw_reset();
}