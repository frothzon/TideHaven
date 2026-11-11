/// @description start spawn


if(!WORLD_READY[WORLD_INDEX]){
	WORLD_READY[WORLD_INDEX] = 1;
	var count = 40;
	repeat(count){
		auto_spawn(spawn_weight, spawn_objects);
	}
}

randomize();
scr_shuffle_array(position_list);
position_index = 0;