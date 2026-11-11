/// @description async spawner


var _spawn = array_pop(object_spawner);
var _splen = array_length(object_spawner);
alarm[2] = 4;
if(_splen < 1){
	exit;
}

/// fast spawn first 3 seconds of game
var _repeat = (current_time-spawn_time_start) < 3000 ? _splen-1 : 1;

while(_repeat-- > 0){
	var _x = _spawn.x + 8 + irandom_range(-4,4);
	var _y = _spawn.y + 16 + irandom_range(-4,4);
		
	if(_spawn.id == 1){
		// sand	
		instance_create_depth(_x, _y, 0, obj_rock);
	} else if(_spawn.id == 2){
		// dirt
		instance_create_depth(_x, _y, 0, obj_bush);
	} else if(_spawn.id == 3){
		// grass
		instance_create_depth(_x, _y, 0, obj_tree);
	}
	if(_repeat > 0){
		_spawn = array_pop(object_spawner);
	}
}