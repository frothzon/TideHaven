// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_step_bag_gui(){
	/// select index
	if(keyboard_check_pressed(vk_tab)){
		bag_index = (bag_index+1) % array_length(bag_list);
		BAG_ITEM_SLOTS.y = display_get_gui_height();
	}
	PLAYER_BAG_CURRENT = bag_list[bag_index % array_length(bag_list)];
	var pos = CAMERA.mouse_gui();
	var xto = pos[0];
	var yto = pos[1];
	BAG_SLOT_HOVER = BAG_ITEM_SLOTS.pointToIndex(xto, yto);
	BAG_GEAR_SEL = BAG_GEAR_SLOT.pointToIndex(xto, yto);
	
	/// selecting items
	if(BAG_SLOT_HOVER < 10 && BAG_SLOT_HOVER >= 0){
		BAG_SLOT_SELECT = BAG_SLOT_HOVER;	
	}
	/// key input selection
	for(var i = 0; i < 10; i++){
		var button = ord(string(i));
		if(keyboard_check_pressed(button)){
			BAG_SLOT_SELECT = i == 0 ? 10 : i-1;
		}
	}
	
	/// manage selector when using gear
	if(BAG_GEAR_SEL >= 0 && BAG_SLOT_SELECT >= 0){
		save_selection = BAG_SLOT_SELECT;
		BAG_SLOT_SELECT = -1;
	}
	if(BAG_SLOT_SELECT < 0 && save_selection >= 0 && BAG_GEAR_SEL < 0){
		BAG_SLOT_SELECT = save_selection;	
	}
}