// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// @func draw_text_outline_sdf_ext(xto, yto, text, text_w, c1=c_black, c2=c_white, outline_w=1)
function draw_text_outline_sdf_ext(_font, xto, yto, text, text_w, c1=c_black, c2=c_white, outline_w=1){
	font_enable_effects(_font, true, {
	    outlineEnable: true,
	    outlineDistance: outline_w,
	    outlineColour: c1
	});
	
	draw_set_color(c2);
	draw_text_ext(xto, yto, text,-1,text_w);

	font_enable_effects(_font, false, {
	    outlineEnable: true,
	    outlineDistance: outline_w,
	    outlineColour: c1
	});
	scr_draw_reset();
}