/// @description draw text


var pos = new scr_vec2_class(x,y);
scr_transform_coordinates(CAMERA, pos, 1);

draw_set_font(fnt_default);
draw_set_halign(fa_middle);
draw_set_valign(fa_center);
size = lerp(size, 3, 0.1);
if(size > 2.5){
	fading = lerp(fading, 0, 0.2);
}

font_enable_effects(fnt_default, true, {
    outlineEnable: true,
    outlineDistance: 1,
    outlineColour: c_black
});

draw_set_alpha(fading);
draw_set_color(image_blend);
draw_text_transformed(pos.x,pos.y+1,text,size,size,0);
scr_draw_reset();

delete pos;

font_enable_effects(fnt_default, false, {
    outlineEnable: true,
    outlineDistance: 1,
    outlineColour: c_black
});