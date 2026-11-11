/// @description Insert drops

scr_destroy_breakable();

/// place item
scr_place_item(x,y, MAT_MEAT, irandom_range(1,5));
if(scr_chance(0.2)){
	drop_gear(,x,y);
}








