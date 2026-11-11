// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_generate_equip_function(inv_bag_obj, gear_slot_obj, gear_slot_index){

	var __this__ = {
		bag_ptr: inv_bag_obj,
		gear_ptr: gear_slot_obj,
		gear_slot: gear_slot_index,
		run: function(_ITEM_){
			scr_bag_add_item(bag_ptr, _ITEM_, -1);
			var _old = gear_ptr.items[gear_slot];
			if(is_struct(_old)){
				_old.snap = false;
				scr_bag_add_item(bag_ptr, _old, 1);
			}
			gear_ptr.items[gear_slot] = _ITEM_;
			gear_ptr.amount[gear_slot] = 1;
			scr_play_sound(snd_use, 0);
			/// gear stats
			scr_update_gear_stats();
			/// snap
			_ITEM_.snap = false;
		}
	}
	
	return(__this__);
}