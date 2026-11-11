/// @description move to mouse for placement

scr_update_builder(-4, false, false, true);

if(mode != 0){
	
	// can plant is false when a plant is already soiled
	can_plant = plant.name == null_name;
	
	if(!can_plant){
		plant.ratio = get_plant_ratio(plant);
		if(plant.state == 0 && plant.ratio >= 1){
			// ready to harvest
			plant.state = 1;
			var _obj = instance_create_depth(x,y,0,obj_mature_plant);
			_obj.plant = plant;
			_obj.soil = id;
		}
		plant.index = floor((sprite_get_number(plant.sprite)-1) * plant.ratio);
	}
	
	if(wet > 0) wet -= 1/room_speed;
}