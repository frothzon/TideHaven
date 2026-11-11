// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_draw_builder_tooltip(){
	if(mode == 0){
		draw_set_halign(fa_center);
		draw_set_font(fnt_s20);
		scr_draw_text_outline(display_get_gui_width()*0.5,64,"Press ESC to cancel",,c_red);
		draw_set_halign(fa_left);
		draw_set_font(fnt_default);
	}
}