// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_setup_dragger(){
	/*
		create struct to handle dragging and dropping inventory items around
	*/
	BAG_DRAGGER = {
		hover: -1,			/// current index being hovered over
		held: -1,			/// current index being dragged
		held_bag: -1,		/// current PLAYER_BAG being dragged from
		item: -1,			/// item data of dragged object
		x_mouse: 0,			/// x position of mouse in GUI
		y_mouse: 0,			/// y position of mouse in GUI
		pause: true			/// turn on/off dragger object
	}
}

function scr_update_dragger(bag_obj, slot_obj){
	
	/// exit if dragger is disabled
	if(!BAG_DRAGGER.pause) return;
	
	/// get mouse position in the GUI layer and set default PLAYER_BAG selection
	var mouse_vec = CAMERA.mouse_gui();
	var bag_selection = bag_obj;
	
	/// update cursor position stored in the dragger object
	BAG_DRAGGER.x_mouse = mouse_vec[0];
	BAG_DRAGGER.y_mouse = mouse_vec[1];
	var xto = mouse_vec[0];
	var yto = mouse_vec[1];
	
	/// select the item slot under the mouse position and add it to the hover variable
	BAG_DRAGGER.hover = BAG_ITEM_SLOTS.pointToIndex(xto, yto);
	if(BAG_DRAGGER.hover == -1){
		BAG_DRAGGER.hover = BAG_GEAR_SLOT.pointToIndex(xto, yto);
		bag_selection = slot_obj;
	}
	
	/// grab item when mouse button is pressed
	if(mouse_check_button_pressed(mb_left)){
		
		/// get the current item being hovered over
		var selection = BAG_DRAGGER.hover;
		
		/// set the hover item to the item being dragged
		BAG_DRAGGER.held = BAG_DRAGGER.hover;
		
		/// store the item and the PLAYER_BAG it comes from
		if(selection >= 0){
			BAG_DRAGGER.item = bag_selection.items[selection];
			BAG_DRAGGER.held_bag = bag_selection;
		}
	}
	
	/// when mouse button is released, drop the item
	if(mouse_check_button_released(mb_left)){
		
		/// drop item
		var _pos = BAG_DRAGGER.hover;
		var _item = BAG_DRAGGER.item;
		
		if(_pos >= 0 && is_struct(_item)){
			
			/// if equipment (number instead of string for id), drop in slot
			/// fixed a bug where you can drop it in the slot object as held bag and get item in bag and slot at same time
			/// by adding BAG_DRAGGER.held_bag != slot_obj
			if(is_real(BAG_DRAGGER.item.id) && bag_selection == slot_obj && _item.use_ptr.gear_slot == _pos && BAG_DRAGGER.held_bag != slot_obj){
				
				/// call item function for equipping item in slot
				_item.use_ptr.run(_item);
				
			} else if(bag_selection == bag_obj && (BAG_DRAGGER.hover != BAG_DRAGGER.held || BAG_DRAGGER.held_bag != bag_selection)){
				if(BAG_DRAGGER.hover >= 0){
					var slot_hover_item = bag_obj.items[BAG_DRAGGER.hover];
					if((BAG_DRAGGER.held_bag == slot_obj && !is_struct(slot_hover_item)) || BAG_DRAGGER.held_bag != slot_obj){
						scr_bag_swap_slots(bag_selection, BAG_DRAGGER.held_bag, BAG_DRAGGER.hover, BAG_DRAGGER.held);
						scr_play_sound(snd_drop, 0);
					} else {
						show_debug_message([BAG_DRAGGER.held_bag == slot_obj, !is_struct(slot_hover_item), slot_hover_item]);
					}
				}
			}
			
		}
		
		/// clear out items after drop
		BAG_DRAGGER.held = -1;
		BAG_DRAGGER.item = -1;
		
		/// recalculate gear
		scr_update_gear_stats();
	}
}

/// draw dragged sprite
function scr_draw_dragger(){
	
	/// do not draw when disabled
	if(!BAG_DRAGGER.pause) return;
	
	/// get position and sprite data for item being dragged
	var _item = BAG_DRAGGER.item;
	var _xto = BAG_DRAGGER.x_mouse;
	var _yto = BAG_DRAGGER.y_mouse;
	
	/// draw item being dragged
	if(BAG_DRAGGER.held >= 0 && is_struct(_item)){
		var size = 48;
		draw_sprite_stretched_ext(_item.sprite, _item.index, _xto-size*0.5, _yto-size*0.5,size,size,c_yellow,0.6);
		//draw_sprite_ext(_item.sprite, _item.index, _xto, _yto,1,1,0,c_yellow,0.6);
	}
}