/// @description create item

// Inherit the parent event
event_inherited();

/// place item
var count = irandom_range(plant.range[0], plant.range[1]);
var _obj = scr_place_item(x,y, plant.drop, count);
_obj.sprite_index = spr_food;
	
// reset soil
with(soil){
	plant = scr_build_plant_data(null_name);
	can_plant = false;
}
