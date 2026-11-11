// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function statscript_potion(item){
	
	
	if(variable_struct_exists(item, "data")){
		if(variable_struct_exists(item.data, "life")){
			
			/// play sound
			scr_play_sound(snd_use, 0);
			
			/// add life to player
			obj_player.life.add(item.data.life);
	
			/// use up item
			scr_bag_add_item(PLAYER_BAG_ITEMS, item, -1);
			
			/// exit
			show_debug_message($"Potion Used {item.data}");
			return;
		}
		
		scr_debug("life not in data struct");
		
		/// exit
		return;
		
	}
	scr_debug("Item data not a struct");
}