// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_shd_toon(drawFcn, tex, lineWidth, arg=-1){
	var upixelH = shader_get_uniform(shd_toon,"pixelH");
	var upixelW = shader_get_uniform(shd_toon,"pixelW");
	var texelW = 0;
	var texelH = 0;
	texelH = lineWidth*texture_get_texel_height(tex);
	texelW = lineWidth*texture_get_texel_width(tex);
	
	shader_set(shd_toon);
	/// set variables to texel size
	shader_set_uniform_f(upixelW,texelW);
	shader_set_uniform_f(upixelH,texelH);
	/// draw stuff
	drawFcn(arg);
	shader_reset();
}