/// @description draw text




var txt = string(cost) + " " + MONEY_TYPE;

if(quantity == 0){
	txt = "Sold Out";
}

draw_set_font(fnt_hud_small);
draw_set_halign(fa_middle);
var mid = (bbox_left+bbox_right) * 0.5;
var pos_price = gui_from_world(mid, bbox_bottom - 8);
scr_draw_text_outline(pos_price.x, pos_price.y, txt,,c_yellow);
draw_set_halign(fa_left);

if(select_quantity && buy_max >= 1){
	buy_quantity = prompt_get_quantity(display_get_gui_width()*0.5, display_get_gui_height()*0.5, 1, buy_max, buy_price);
	draw_text(16,64,buy_timer);
}







