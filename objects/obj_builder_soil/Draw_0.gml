/// @description draw self

/// check neighbors
image_index = position_meeting(bbox_right+8,y-8,obj_builder_soil);
image_index |= 2*position_meeting(x,bbox_top-8,obj_builder_soil);
image_index |= 4*position_meeting(bbox_left-8,y-8,obj_builder_soil);
image_index |= 8*position_meeting(x,bbox_bottom+8,obj_builder_soil);

image_alpha = 1;
image_xscale = scaling.x;
image_yscale = scaling.y;

scr_draw_build_mode();
draw_self();

image_xscale = 1;
image_yscale = 1;


if(!can_plant){
	// update plant
	if(sprite_exists(plant.sprite)){
		draw_sprite(plant.sprite, plant.index, x, y);
		//draw_text(x,y-32,plant.ratio);
	}
}