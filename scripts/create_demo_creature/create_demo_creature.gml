// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_demo_creature(seed_index){
	CSJ_ini_shd_outline();
	CSJ_ini_creature(seed_index);
	sprite_list = CSJ_render_8d_creature();
}