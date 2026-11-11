/// @description collect item

if(scr_check_instance(obj_player_bag)){
	scr_bag_add_item(PLAYER_BAG_ITEMS, item, amount);
	scr_play_sound(snd_collect, 0);
	instance_destroy();
}