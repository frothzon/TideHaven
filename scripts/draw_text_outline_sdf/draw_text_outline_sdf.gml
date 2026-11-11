// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_text_outline_sdf(_font, xto, yto, text, c1=c_black, c2=c_white, outline_w=1){
	font_enable_effects(_font, true, {
	    outlineEnable: true,
	    outlineDistance: outline_w,
	    outlineColour: c1
	});
	
	draw_set_color(c2);
	draw_text(xto, yto, text);

	font_enable_effects(_font, false, {
	    outlineEnable: true,
	    outlineDistance: outline_w,
	    outlineColour: c1
	});
	scr_draw_reset();
}