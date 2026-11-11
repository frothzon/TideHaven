/// @description draw it


var spr = item.sprite;
var ind = item.index;

if(quantity != 0){
	draw_sprite_ext(spr, ind, x, y, 1, 1, 0, c_white, 1);
} else {
	draw_self();	
}

if(in_range && quantity != 0){
	draw_set_font(fnt_hud_small);
	draw_set_halign(fa_middle);
	var mid = (bbox_left+bbox_right) * 0.5;
	var yy = bbox_top-24 + scr_wave(-3,3,2,0);
	scr_draw_text_outline(mid,yy,"!",,c_lime);
	draw_set_halign(fa_left);
}