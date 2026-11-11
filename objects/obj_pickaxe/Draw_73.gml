/// @description draw selector

/*
selector_inst = noone;
selector_frame = 0;
selector_count = sprite_get_number(spr_selector);
*/
if(scr_check_instance(selector_inst)){
	with(selector_inst){
		draw_sprite_ext(spr_selector, other.selector_frame, bbox_left, bbox_top, 1, 1 , 0, c_white, 1);
		draw_sprite_ext(spr_selector, other.selector_frame, bbox_right, bbox_top, 1, 1, -90, c_white, 1);
		draw_sprite_ext(spr_selector, other.selector_frame, bbox_right, bbox_bottom, 1, 1, 180, c_white, 1);
		draw_sprite_ext(spr_selector, other.selector_frame, bbox_left, bbox_bottom, 1, 1, 90, c_white, 1);
		
		/// hp bar
		scr_draw_bar(spr_harvest_bar, x - 8, bbox_bottom + 3, 16, 6, life.ratio());
	}
	
	selector_frame += 0.15;
	if(selector_frame > selector_count) selector_frame -= selector_count;
	
	selector_inst = noone;
}