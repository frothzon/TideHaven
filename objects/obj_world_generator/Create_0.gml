/// @description setup world generator

random_set_seed(scr_get_current_seed());

/// set player
var pos = INITIAL_LAND_SIZE/2;
instance_create_depth(pos, pos, 0, obj_player);

//scr_gen_terrain(scr_get_room_type());
scr_gen_terrain(0);

scr_shuffle_array(position_list);

spawn_weight = [25, 15, 5, 1];
spawn_objects = [obj_bush, obj_tree, obj_rock, obj_monster_parent];
alarm[0] = room_speed * 5;

position_index = 0;
get_next_index = function(){
	var ind = position_index++;
	if(position_index >= array_length(position_list)){
		scr_shuffle_array(position_list);
		position_index = 0;
	}
	return(ind);
}


auto_spawn = function(wght, objlist){
	/// game start placement
	var pos = position_list[get_next_index()];
	var xx = pos[0];
	var yy = pos[1];
	var ind = scr_random_weighted(wght);
	var skip = 20;
	while(scr_place_meeting_list(xx,yy,[obj_breakable_parent, obj_floor_parent, obj_player])){
		pos = position_list[get_next_index()];
		xx = pos[0];
		yy = pos[1];
		if(skip-- < 0) break;
	};
	
	/// create instance at new position
	if(skip > 0) instance_create_depth(xx,yy,0,objlist[ind]);
}

alarm[1] = 2;