/// @description update camera

scr_cam_update(CAMERA);
scr_update_tooltip(TOOLTIPS);
if(fishing_cooldown > 0) fishing_cooldown--;

/// One menu view owns the controls at a time. P: inventory, M: world map, B: skills.
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