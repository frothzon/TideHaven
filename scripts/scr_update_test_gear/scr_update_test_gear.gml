// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_update_test_gear(){
	gear_cooldown = max(0, gear_cooldown-1);
	
	/// change BAG_DRAGGER state to on/off
	BAG_DRAGGER.pause = BAG_PAUSED;
	
	/// change inventory position when puased
	BAG_ITEM_SLOTS.ymove = BAG_PAUSE_POS[BAG_PAUSED];
	BAG_TAB_SLOTS.ymove = BAG_PAUSE_POS[BAG_PAUSED] - GUI_BLOCK_SIZE - 4;
	
	/// update gui position
	BAG_ITEM_SLOTS.update();

}