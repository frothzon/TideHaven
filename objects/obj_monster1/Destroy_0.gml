/// @description create item

// Inherit the parent event
event_inherited();

/// place item
scr_place_item(x,y, MAT_MEAT, irandom_range(1,5));
if(scr_chance(0.2)){
	scr_place_item(x,y, MAT_GOLD, irandom_range(1,5));
}
