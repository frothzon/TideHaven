/// @description start spawn


if(!WORLD_READY[WORLD_INDEX]){
	WORLD_READY[WORLD_INDEX] = 1;
	var count = 40;
	repeat(count){
		auto_spawn(spawn_weight, spawn_objects);
	}

	/// Place one guaranteed sword chest near the fresh player spawn.
	var _player = instance_find(obj_player, 0);
	if(scr_check_instance(_player)){
		var _offsets = [];
		var _distances = [48,64,80,96,112];
		for(var _ring = 0; _ring < array_length(_distances); _ring++){
			var _distance = _distances[_ring];
			array_push(_offsets, [_distance,0], [-_distance,0], [0,_distance], [0,-_distance], [_distance,_distance], [-_distance,_distance], [_distance,-_distance], [-_distance,-_distance]);
		}
		var _place = -1;
		for(var i = 0; i < array_length(_offsets); i++){
			var _x = _player.x + _offsets[i][0];
			var _y = _player.y + _offsets[i][1];
			if(scr_tile_at_position(_x, _y, "lay_sand")
			&& !scr_place_meeting_list(_x, _y, [obj_breakable_parent, obj_floor_parent, obj_player])){
				_place = {x: _x, y: _y};
				break;
			}
		}
		if(is_struct(_place)){
			var _chest = instance_create_depth(_place.x, _place.y, 0, obj_chest);
			var _bag = instance_find(obj_player_bag, 0);
			if(scr_check_instance(_bag)){
				_chest.drop_item_list = [new scr_tool_class("Wooden Sword", spr_bag_items, 0, _TOOL_.sword, _bag.equip_weapon, -1, 1, "damage")];
				_chest.drop_item_weights = [1];
				_chest.drop_quantities = [1];
			}
		}
	}
}

randomize();
scr_shuffle_array(position_list);
position_index = 0;