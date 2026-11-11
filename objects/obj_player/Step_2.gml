/// @description update camera

scr_cam_update(CAMERA);
scr_update_tooltip(TOOLTIPS);
if(fishing_cooldown > 0) fishing_cooldown--;

/// One menu view owns the controls at a time. P: inventory, M: world map, B: skills.
if(keyboard_check(vk_control) && keyboard_check_pressed(ord("S"))){
	if(CURRENT_AREA == AREA_OVERWORLD) scr_roomEndSaveState();
	if(scr_save_game()) scr_show_text_float(x, y - 20, "Game saved", c_lime);
}

if(CURRENT_AREA == AREA_OVERWORLD && MENU_VIEW == MENU_VIEW_GAME && !GAME_PAUSED && !global.CONFIG.housing_template_active && keyboard_check(vk_control)){
	if(keyboard_check_pressed(ord("H"))){
		if(!scr_capture_housing_template(x, y)) scr_show_text_float(x, y - 20, "No placed house pieces nearby", c_yellow);
	} else if(keyboard_check_pressed(ord("J"))){
		var _template_count = array_length(global.CONFIG.housing_templates);
		if(_template_count > 0){
			global.CONFIG.housing_template_index = (global.CONFIG.housing_template_index + 1) mod _template_count;
			var _template = global.CONFIG.housing_templates[global.CONFIG.housing_template_index];
			scr_show_text_float(x, y - 20, "Selected " + _template.name, c_aqua);
		}
	} else if(keyboard_check_pressed(ord("T"))){
		var _template_count = array_length(global.CONFIG.housing_templates);
		if(_template_count > 0){
			var _index = clamp(global.CONFIG.housing_template_index, 0, _template_count - 1);
			var _template = global.CONFIG.housing_templates[_index];
			if(is_array(scr_housing_template_costs(_template, PLAYER_BAG_ITEMS))){
				var _preview = instance_create_depth(mouse_x, mouse_y, 0, obj_builder_floor);
				_preview.housing_template_preview = true;
				_preview.template_index = _index;
				_preview.item = -1;
				_preview.mode = 0;
				global.CONFIG.housing_template_active = true;
			} else {
				scr_show_text_float(x, y - 20, "Need the saved house pieces in your inventory", c_yellow);
			}
		}
	}
}

if(!GAME_PAUSED){
	var _next_view = MENU_VIEW;
	if(keyboard_check_pressed(vk_escape) && MENU_VIEW != MENU_VIEW_GAME){
		_next_view = MENU_VIEW_GAME;
	} else if(keyboard_check_pressed(ord("P"))){
		_next_view = MENU_VIEW == MENU_VIEW_INVENTORY ? MENU_VIEW_GAME : MENU_VIEW_INVENTORY;
	} else if(keyboard_check_pressed(ord("M"))){
		_next_view = MENU_VIEW == MENU_VIEW_MAP ? MENU_VIEW_GAME : MENU_VIEW_MAP;
	} else if(keyboard_check_pressed(ord("B"))){
		_next_view = MENU_VIEW == MENU_VIEW_SKILLS ? MENU_VIEW_GAME : MENU_VIEW_SKILLS;
	}

	if(_next_view != MENU_VIEW){
		var _was_skills = MENU_VIEW == MENU_VIEW_SKILLS;
		MENU_VIEW = _next_view;
		BAG_PAUSED = MENU_VIEW != MENU_VIEW_GAME;
		show_skills = MENU_VIEW == MENU_VIEW_SKILLS;
		map.show = MENU_VIEW == MENU_VIEW_MAP;
		if(show_skills && !_was_skills){
			instance_deactivate_object(obj_player_bag);
		} else if(!show_skills && _was_skills){
			instance_activate_object(obj_player_bag);
		}
		scr_play_sound(snd_pause, 0);
	}
}

/// move water effect
var _eff = get_water_effect();
var _dx = -(CAMERA.x * CAMERA.ratio[0]);
var _dy = -(CAMERA.y * CAMERA.ratio[1]);
fx_set_parameter(_eff, "g_RipplesPosition", [_dx, _dy]);
/// move to new room

/// energy regen?
var regen_rate = (1/room_speed) * 0.1;
stamina.add(regen_rate);
