// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_draw_bag_gui(bag, font = fnt_hud_small, bag_sprite = spr_inv_slot, bg_sprite = spr_inv_box, info_sprite = spr_inv_info, select_sprite = spr_inv_selector){
	
	/// draw bag name
	/*
	draw_set_font(font);
	box = BAG_ITEM_SLOTS.cellRect(0);
	var name = PLAYER_BAG_CURRENT.name;
	scr_draw_text_outline(box.x, box.y-24, scr_concat(name, " <tab to next>"));
	*/
	/// draw items
	var _bounds = BAG_ITEM_SLOTS.bounds();
	draw_sprite_stretched(bg_sprite, 0, _bounds.x-10, _bounds.y-10, _bounds.w+20, _bounds.h+20);
	for(var i = 0; i < BAG_SLOT_AMT; i++){
		var box = BAG_ITEM_SLOTS.cellRect(i);
		var ind = BAG_SLOT_HOVER==i;
		draw_set_font(font);
		draw_sprite_stretched(bag_sprite, ind, box.x, box.y, box.w, box.h);
		scr_draw_text_outline(box.x+4, box.y+2, (i+1),c_black,c_white,2);
		/// draw item
		var _item = bag.items[i];
		var _qty = bag.amount[i];
		if(is_struct(_item)){
			var _move = _item.snap ? 1.0 : 0.25;
			_item.xdraw = lerp(_item.xdraw, box.x, _move);
			_item.ydraw = lerp(_item.ydraw, box.y, _move);
			if(!_item.snap){
				if(point_distance(_item.xdraw, _item.ydraw, box.x, box.y) < 1){
					_item.snap = true;
				}
			}
			draw_sprite_stretched(_item.sprite, _item.index, _item.xdraw, _item.ydraw, box.w, box.h);
			if(_qty > 1){
				/// draw quantity
				var qty_string = string_number_formatted(_qty);
				draw_set_halign(fa_right);
				draw_set_valign(fa_bottom);
				scr_draw_text_outline(box.x+GUI_BLOCK_SIZE, box.y+GUI_BLOCK_SIZE, qty_string,,c_lime,2);
				scr_draw_reset();
			}
		}
		if(i == BAG_SLOT_SELECT){
			var _offset = scr_wave(0, 4, 1, 0);
			draw_sprite_stretched(select_sprite, 0, box.x+_offset, box.y+_offset, box.w-_offset*2, box.h-_offset*2);
		}
	}
	draw_set_font(font);
	/// draw selected item
	if(BAG_SLOT_HOVER >= 0 && BAG_SLOT_SELECT == BAG_SLOT_HOVER){
		var __selected = bag.items[BAG_SLOT_HOVER];
		if(is_struct(__selected)){
			
			//----------------------- setup box size -----------------------------------//
			
			if(!BAG_PAUSED){
				var helper = "\nPress #gEE#w to use\nPress #rXX#w to trash!"
				if(ITEM_TYPE.recipe && variable_struct_exists(__selected, "can_craft")){
					if(__selected.can_craft){
						helper = "\nPress #gE#w to craft!";
					} else {
						helper = "\n#xPress EE to craft!#w";
					}
				}
				helper = string_replace_all(helper, "EE", chr(KEY_EQUIP));
				if(__selected.type != ITEM_TYPE.recipe) helper = string_replace(helper,"XX", chr(KEY_DELETE));
				
				var str = scr_concat(__selected.toString(), helper);
				var ww = string_width(str) + 32;
				var hh = string_height(str) + 84;
			
				BAG_GUI_DESC_BOX.x = display_get_gui_width()*0.5 - ww*0.5;
				BAG_GUI_DESC_BOX.y = display_get_gui_height()*0.5 - hh*0.5;
				BAG_GUI_DESC_BOX.w = ww;
				BAG_GUI_DESC_BOX.h = hh;
				var __box = BAG_GUI_DESC_BOX;
				var icon_size = 64;
				var box_mid_x = __box.x + __box.w*0.5;
				var box_mid_y = __box.y + icon_size*0.5;
			
				draw_set_alpha(1);
				draw_set_color(c_black);

				draw_sprite_stretched(info_sprite, 0, __box.x-8, __box.y-8, __box.w+16, __box.h+16);
			
				draw_sprite_stretched(__selected.sprite, __selected.index, box_mid_x-icon_size*0.5, box_mid_y-icon_size*0.5,icon_size,icon_size);
			
				draw_set_font(CSTM_FONT);
				tb_draw_textbox(__box.x+__box.w/2, __box.y+__box.h - 8, str, string_length(str),-1,c_black,0);
				//scr_draw_text_outline(__box.x+16, __box.y+74, str,,c_white,2);
				scr_draw_reset();
			} 
			
		}
	}
	if(BAG_SLOT_SELECT >= 0){
		var __selected = bag.items[BAG_SLOT_SELECT];
		if(is_struct(__selected)){
			///---------------------------------- key useage ---------------------------///
			if(keyboard_check_pressed(KEY_EQUIP) || mouse_check_button_pressed(mb_right)){
				if(use_item_timer > 0) exit;
				use_item_timer = 10;
				//scr_print("test");
				var used = 0; /// whether item is consumed
				/// use item
				if(__selected.use_item != -1 && __selected.use_item != undefined){
					__selected.snap = false;
					used = __selected.use_item(__selected, PLAYER_BAG_ITEMS);
				}
				if(used) {
					scr_print("Consumed: ", __selected.name);
					scr_bag_add_item(PLAYER_BAG_ITEMS, __selected, -1);
				}
			}
			if(keyboard_check_pressed(KEY_DELETE) && __selected.type != ITEM_TYPE.recipe){
				if(use_item_timer > 0) exit;
				use_item_timer = 10;
				/// play sound
				scr_play_sound(snd_delete_item, 0);
				/// destroy item
				scr_bag_add_item(bag, __selected, -1);
			}
		}
	}
}