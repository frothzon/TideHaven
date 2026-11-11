/// @description start position

var _pos = get_random_spawn_location();
x = _pos.x;
y = _pos.y;

var dx = 16;
var dy = 16;
map.build(["lay_walls", "lay_sand", "lay_dirt", "lay_grass"], [ #224488, #995522, #773311, #445522], room_width div dx, room_height div dy, dx, dy);

spawn_points = [{x: 0, y: 0}];
var chunk = get_world_chunk_size();
var cx = (CAMERA.w div chunk)+4;
var cy = (CAMERA.h div chunk)+4;
for(var i = -2; i < cx; i++){
	for(var j = -2; j < cy; j++){
		array_push(spawn_points, {x: i * chunk, y: j * chunk});
	}
}