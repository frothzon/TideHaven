/// @description setup world generator

if(CURRENT_AREA == AREA_DUNGEON){
	dungeon_scene = true;
	depth = -50;
	visible = true;
	global.CONFIG.dungeon_scene_objects = [];
	array_push(global.CONFIG.dungeon_scene_objects, id);
	global.CONFIG.dungeon_bounds = {left:x-480, right:x+480, top:y-160, bottom:y+160};

	var _make_scene_object = function(_instance){
		if(scr_check_instance(_instance)){
			_instance.dungeon_scene_object = true;
			array_push(global.CONFIG.dungeon_scene_objects, _instance);
		}
		return _instance;
	};
	var _make_wall = function(_wx, _wy){
		var _wall = instance_create_depth(_wx, _wy, -80, obj_wall);
		_wall.sprite_index = spr_wall_tile;
		_make_scene_object(_wall);
	};

	// Clear any generated map collision and resource spawns under the fixed cave layout.
	var _world = instance_find(perlin_world, 0);
	global.CONFIG.dungeon_saved_wall_cells = [];
	if(scr_check_instance(_world)){
		var _first = _world.position_to_grid(x-480, y-160);
		var _last = _world.position_to_grid(x+480, y+160);
		for(var _cy = _first.y; _cy <= _last.y; _cy++){
			for(var _cx = _first.x; _cx <= _last.x; _cx++){
				if(_cx >= 0 && _cy >= 0 && _cx < ds_grid_width(_world.grid[0]) && _cy < ds_grid_height(_world.grid[0])){
					var _old_tile = tilemap_get(_world.map_walls, _cx, _cy);
					array_push(global.CONFIG.dungeon_saved_wall_cells, {x:_cx, y:_cy, data:_old_tile});
					tilemap_set(_world.map_walls, 0, _cx, _cy);
				}
			}
		}
	}
	var _bounds = global.CONFIG.dungeon_bounds;
	with(obj_breakable_parent){
		if(point_in_rectangle(x, y, _bounds.left, _bounds.top, _bounds.right, _bounds.bottom)) instance_destroy();
	}

	var _left = x-480;
	var _hall_start = x-240;
	var _hall_end = x+240;
	var _right = x+480;
	for(var _wx = _left; _wx < _hall_start; _wx += 32){
		_make_wall(_wx, y-128);
		_make_wall(_wx, y+96);
	}
	for(var _wx = _hall_start; _wx < _hall_end; _wx += 32){
		_make_wall(_wx, y-64);
		_make_wall(_wx, y+32);
	}
	for(var _wx = _hall_end; _wx < _right; _wx += 32){
		_make_wall(_wx, y-128);
		_make_wall(_wx, y+96);
	}
	for(var _wy = y-128; _wy <= y+96; _wy += 32){
		_make_wall(_left, _wy);
		_make_wall(_right, _wy);
	}

	var _exit = instance_create_depth(_left+64, y, 0, obj_npc_parent);
	_exit.dungeon_exit = true;
	_exit.interaction_range = 64;
	_exit.depth = -1000;
	_exit.sprite_index = spr_door_locked;
	_make_scene_object(_exit);
	var _shrine = instance_create_depth(_right-80, y, 0, obj_npc_parent);
	_shrine.dungeon_shrine = true;
	_shrine.interaction_range = 64;
	_shrine.depth = -1000;
	_shrine.sprite_index = spr_chest_anim;
	_make_scene_object(_shrine);
	var _sign = instance_create_depth(_right-144, y+48, 0, obj_npc_parent);
	_sign.dungeon_sign = true;
	_sign.interaction_range = 64;
	_sign.depth = -1000;
	_sign.messages = "The Tide Shrine rests beyond this chamber. Press E at the chest, then return to the entrance door.";
	_make_scene_object(_sign);
	exit;
}

random_set_seed(scr_get_current_seed());

/// set player
var pos = INITIAL_LAND_SIZE/2;
instance_create_depth(pos, pos, 0, obj_player);

//scr_gen_terrain(scr_get_room_type());
scr_gen_terrain(0);

scr_shuffle_array(position_list);

spawn_weight = [25, 15, 5, 1, 2];
spawn_objects = [obj_bush, obj_tree, obj_rock, obj_monster_parent, obj_chest];
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
	var skip = 20;
	while(scr_place_meeting_list(xx,yy,[obj_breakable_parent, obj_floor_parent, obj_player])){
		pos = position_list[get_next_index()];
		xx = pos[0];
		yy = pos[1];
		if(skip-- < 0) break;
	};
	
	/// create instance at new position
	if(skip > 0){
		var _biome_weights = wght;
		switch(scr_get_biome_at_position(xx, yy)){
			case BIOME_COAST: _biome_weights = [32, 8, 3, 1, 2]; break;
			case BIOME_GROVE: _biome_weights = [18, 34, 5, 1, 2]; break;
			case BIOME_HIGHLAND: _biome_weights = [12, 6, 24, 4, 2]; break;
		}
		var ind = scr_random_weighted(_biome_weights);
		instance_create_depth(xx, yy, 0, objlist[ind]);
	}
}

alarm[1] = 2;
