// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_draw_tab_gui(tab_sprite = spr_tab_simple, tab_icons = spr_tab_icons){
	var _pad = 8;
	var _pw = _pad*2;
	var mouse_vec = CAMERA.mouse_gui();
	for(var i = 0; i < BAG_TAB_COUNT; i++){
		var _rect = BAG_TAB_SLOTS.cellRect(i);
		var _ind = i == bag_index ? 0 : 1;
		var _hh = _rect.h;
		if(_ind == 0){
			_rect.y -= 10;
			_rect.h += 10;
		}
		/// check if mouse is hovering over the tab
		var _select = point_in_rectangle(mouse_vec[0], mouse_vec[1], _rect.x, _rect.y, _rect.x2(), _rect.y2());
		if(_select){
			_ind = 2;	
			/// change the selection here
			if(mouse_check_button(mb_left)){
				bag_index = i;
			}
		}
		
		/// draw tab and tab icon here
		
		if(_ind == 1){
			draw_sprite_stretched_ext(tab_sprite, _ind, _rect.x-3, _rect.y, _rect.w+6, _rect.h,c_ltgray,1);
			draw_sprite_stretched_ext(tab_icons, i, _rect.x+_pad, _rect.y+_pad, _rect.w-_pw, _hh-_pw,c_ltgray,0.75);
		} else {
			draw_sprite_stretched(tab_sprite, _ind, _rect.x-3, _rect.y, _rect.w+6, _rect.h);
			draw_sprite_stretched(tab_icons, i, _rect.x+_pad, _rect.y+_pad, _rect.w-_pw, _hh-_pw);
		}
	}
}