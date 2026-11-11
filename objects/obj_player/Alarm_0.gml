/// @description deactivating objects outside view

/// get spawn locations
var _check = array_length(spawn_points);
for(var _i = 0; _i < _check; _i++){
	var _pt = spawn_points[_i];
	var _xx = CAMERA.x + _pt.x;
	var _yy = CAMERA.y + _pt.y;
	var spawn_locations = get_world_spawn_chunk(_xx, _yy);
	var _splen = array_length(spawn_locations);
	if(_splen > 0){
		object_spawner = array_concat(object_spawner, spawn_locations);
	}
}

scr_disable_outside_view(CAMERA, obj_wall);
scr_disable_outside_view(CAMERA, obj_respawn);

alarm[0] = 5;