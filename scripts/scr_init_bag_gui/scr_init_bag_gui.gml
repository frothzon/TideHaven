// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_init_bag_gui(){
	//------------- create inventory draw location -----------//

	/// Create grid for slots in main PLAYER_BAG
	BAG_ITEM_SLOTS = new scr_display_grid_class(
		display_get_gui_width()*0.5-BAG_SLOT_AMT*GUI_BLOCK_SIZE/6,
		display_get_gui_height()-GUI_BLOCK_SIZE,
		GUI_BLOCK_SIZE,GUI_BLOCK_SIZE,BAG_SLOT_AMT/3,3
	);
	
	BAG_TAB_SLOTS = new scr_display_grid_class(
		display_get_gui_width()*0.5 - BAG_TAB_COUNT * GUI_BLOCK_SIZE/2,
		BAG_ITEM_SLOTS.y - BAG_ITEM_SLOTS.height - GUI_BLOCK_SIZE,
		GUI_BLOCK_SIZE, GUI_BLOCK_SIZE, 7, 1
	);

	/// create box for item description text
	BAG_GUI_DESC_BOX = new scr_rect_class(
		display_get_gui_width()*0.5 - 128,
		display_get_gui_height()*0.5 - 28,
		256,
		256
	);
	
	/// create location for drawing PAUSE
	BAG_PAUSE_POS = [display_get_gui_height()-GUI_BLOCK_SIZE,display_get_gui_height()-GUI_BLOCK_SIZE*3-9];
	
	//-------------------- eqquipped PLAYER_GEAR -------------//
	BAG_GEAR_SEL = -1;	/// item being selected by mouse
	
	/// create grid for equipped items
	BAG_GEAR_SLOT = new scr_display_grid_class(
		display_get_gui_width() - GUI_ITEM_SIZE*1.2,
		GUI_ITEM_SIZE * 0.5, GUI_ITEM_SIZE, GUI_ITEM_SIZE, 1, 5
	);
	
	use_item_timer = 0;
	save_selection = -1;
}