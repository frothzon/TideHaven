/// @description setup

draw_self();

if(in_range && state == 0){
	draw_set_font(fnt_hud_small);
	draw_set_halign(fa_middle);
	var mid = (bbox_left+bbox_right) * 0.5;
	var yy = bbox_top-24 + scr_wave(-3,3,2,0);
	scr_draw_text_outline(mid,yy,"!",,c_lime);
	draw_set_halign(fa_left);
}



