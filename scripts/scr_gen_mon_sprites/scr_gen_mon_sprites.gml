// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_gen_mon_sprites(){
/*
#macro CREATURE_SEEDS global.CONFIG.creature_list
#macro CREATURE_SPRITES global.CONTROLLER.mon_sprites
*/

	show_debug_message("loading sprites...");
	var len = array_length(CREATURE_SEEDS);
	for(var i = 0; i < len; i++){
		CSJ_ini_creature(CREATURE_SEEDS[i]);
		var sprite_list = CSJ_render_8d_creature();
		array_push(CREATURE_SPRITES, sprite_list);
		array_push(CREATURE_NAMES, CSJ_name_generator(CREATURE_SEEDS[i]));
	}
	image_angle = 0;
	show_debug_message("loading sprites done.");
}

/// get shader ready
function scr_ini_mon_outline(spr){
	CSJ_ini_shd_outline();
	shd_set_texel(spr, 1);
}