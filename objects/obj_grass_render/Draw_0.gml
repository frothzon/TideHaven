/// @description draw grass

gpu_set_ztestenable(true);
time += 0.03;
var u_time = shader_get_uniform(shd_grass, "u_time");
shader_set(shd_grass);
shader_set_uniform_f(u_time, time);
grass_gen.render();
shader_reset();

/// draw tilesets
for(var i = 0; i < array_length(tileset_array); i++){
	tileset_array[i].render();	
}
gpu_set_ztestenable(false);
