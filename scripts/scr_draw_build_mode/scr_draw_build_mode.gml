// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_draw_build_mode(){
	if(fade > 0){
		gpu_set_blendmode(bm_add);
		draw_sprite_tiled_ext(spr_build_grid, 0, 0, 0,1,1,c_white,fade);
		gpu_set_blendmode(bm_normal);
		var col = is_safe ? c_lime : c_red;
		draw_set_alpha(fade);
		draw_set_color(col);
		draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, 1);
		draw_set_color(c_white);
		draw_arrow(x,bbox_top-8,x,bbox_top,5);
		draw_set_alpha(1);
		image_alpha = 0.5;
	}
}