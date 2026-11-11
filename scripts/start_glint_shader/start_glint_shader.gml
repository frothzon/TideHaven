// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function start_glint_shader(time, offset, from=1, to=3){
	
	/// setup timing
	var ts = current_time/1000;
	var ratio = ((ts + offset) % time) / time;
	var timeStep = lerp(from, to, ratio);
	
	/// set shader and uniform
	var _time = shader_get_uniform(shd_glint, "u_time");
	shader_set(shd_glint);
	shader_set_uniform_f(_time, timeStep);
}