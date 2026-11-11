// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_draw_gear_gui(bag, bag_return, font = fnt_hud_small, bag_sprite = spr_inv_slot, info_sprite = spr_inv_info, select_sprite = spr_inv_selector){
	
	/// draw items
	draw_set_font(font);
	for(var i = 0; i < 5; i++){
		var box = BAG_GEAR_SLOT.cellRect(i);
		var ind = BAG_GEAR_SEL==i;
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
				draw_set_halign(fa_right);
				draw_set_valign(fa_bottom);
				scr_draw_text_outline(box.x+BAG_GUI_DESC_BOX.w, box.y+BAG_GUI_DESC_BOX.h, _qty,,c_lime,2);
				scr_draw_reset();
			}
		}
		
		if(ind > 0){
			var _offset = scr_wave(0, 4, 1, 0);
			draw_sprite_stretched(select_sprite, 0, box.x+_offset, box.y+_offset, box.w-_offset*2, box.h-_offset*2);
		}
	}
	
	/// draw selected item
	if(BAG_GEAR_SEL >= 0){
		var __selected = bag.items[BAG_GEAR_SEL];
		if(is_struct(__selected)){
			
			//----------------------- setup box size -----------------------------------//
			var str = scr_concat(__selected.toString(),"\nPress #rX#w to unequip!");
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
			tb_draw_textbox(__box.x+__box.w/2, __box.y+__box.h-8, str, string_length(str),-1,c_black,0);
			//scr_draw_text_outline(__box.x+16, __box.y+74, str,,c_white,2);
			
			
			scr_draw_reset();
			
			///---------------------------------- key useage ---------------------------///
			if(keyboard_check_pressed(ord("X"))){
				if(use_item_timer > 0) exit;
				use_item_timer = 10;
				
				/// play sound
				scr_play_sound(snd_delete_item, 0);
				
				/// destroy item
				__selected.snap = false;
				scr_bag_add_item(bag_return, __selected, 1);
				scr_bag_add_item(bag, __selected, -1);
				
				/// recalculate
				scr_update_gear_stats();
			}
		}
	}
}