/// @description update camera

scr_cam_update(CAMERA);
scr_update_tooltip(TOOLTIPS);
if(keyboard_check_pressed(ord("M"))){
	map.show = !map.show;
	show_debug_message(map);
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