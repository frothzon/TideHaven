/// @description open chest

image_index = state > 0;

switch(state){
	case 0:
		if(in_range && keyboard_check_pressed(KEY_EQUIP)){

			state = 1;
			
			if(array_length(item_list) > 0){
				var ind = scr_random_weighted(item_weight);
				var item = item_list[ind];
				var bag = item.type == ITEM_TYPE.tool ? PLAYER_BAG_TOOLS : PLAYER_BAG_ITEMS;
				var can_add = scr_bag_add_item(bag, item, 1);
			
				if(!can_add){
					scr_showMessage(scr_concat("Can't hold anymore ", item.name, "(s)!"), 0, ["ok"],
						function(key){
							state = 0;
						}
					);
				} else {
					scr_showMessage(scr_concat("Found ", item.name, "!"), 0, ["ok"]);
					/*
						play a sequence or animation of finding the item
					*/
					if(bag == PLAYER_BAG_TOOLS){
						scr_play_sound(OGG_Heroic_Win_Sting, 0);	
					} else {
						scr_play_sound(snd_collect, 0);	
					}
				}
			}
		}
	break;
	case 1:
		/// drop an item if setup for it
		if(array_length(obj_drop_list) > 0){
			var ind = scr_random_weighted(item_weight);
			instance_create_depth(obj_player.x,obj_player.y,0,obj_drop_list[ind]);
		}
		state = 2;
	break;
	case 2:
		/// do nothing
	break;
}

/*
scr_bag_add_item(bag, item, 1);
*/



