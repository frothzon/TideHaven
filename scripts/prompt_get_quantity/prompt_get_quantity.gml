// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function prompt_get_quantity(xdraw, ydraw, minval, maxval, costval){
	var shift = keyboard_check_pressed(KEY_UP) - keyboard_check_pressed(KEY_DOWN);
	shift += mouse_wheel_up() - mouse_wheel_down();
	
	BUY_AMOUNT = clamp(BUY_AMOUNT + shift, minval, maxval);
	var txt = "Quantity Wanted: ..." + string(BUY_AMOUNT) + " (" + string(maxval) + " MAX)\nUP|DOWN and E to select";
	var txtcost = "Cost " + string(costval) + " " + MONEY_TYPE;
	
	draw_set_halign(fa_middle);
	draw_set_valign(fa_left);
	draw_set_font(fnt_hud_small);
	
	var ww = string_width(txt);
	var hc = string_height(txtcost);
	var hh = string_height(txt) + hc;
	
	draw_sprite_stretched(spr_textbox, 0, xdraw - 0.5 * ww - 8, ydraw - 8, ww + 16, hh+16);
	scr_draw_text_outline(xdraw, ydraw, txt);
	scr_draw_text_outline(xdraw, ydraw+hh-hc, txtcost,,costval > MONEY ? c_red : c_lime);
	
	return(BUY_AMOUNT);
}