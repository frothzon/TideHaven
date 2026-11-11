/// @description draw level stuff

draw_set_font(fnt_hud_small);
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

switch(MENU_VIEW){
	case MENU_VIEW_INVENTORY:
		var _stats = scr_concat(life.toString(),"\n",damage.toString(),"\n",spd.toString(),"\n",stamina.toString());
		scr_draw_text_outline(16, 32, _stats);
	break;
	case MENU_VIEW_GAME:
		draw_set_halign(fa_left);
		var _txt = scr_concat("LVL. ", STAT_LEVEL);
		var _ww = string_width(_txt);
		var _wbar = 200;
		var _xmid = _gui_w * 0.5 - _wbar * 0.5 - _ww;
		scr_draw_text_outline(_xmid, 16, _txt);
		scr_draw_bar(spr_exp_bar, _xmid + _ww + 24, 16, _wbar, 16, STAT_EXP.ratio());
		if(STAT_POINTS > 0){
			var _val = scr_wave(0, 1, 0.5, 0);
			var _col = merge_color(c_white, c_yellow, _val);
			scr_draw_text_outline(16, 64, scr_concat("Points: ", STAT_POINTS),, _col);
		}
		scr_draw_text_outline(80, 16, string(STAT_LIFE));
		scr_draw_bar(spr_health_bar, 16, 16, 60, 16, life.ratio(), c_red, c_lime);
		scr_draw_text_outline(80, 48, string(STAT_ENERGY));
		scr_draw_bar(spr_health_bar, 16, 48, 60, 16, stamina.ratio(), c_purple, c_aqua);
		textbox.draw();
	break;
	case MENU_VIEW_MAP:
		draw_set_halign(fa_left);
		scr_draw_text_outline(24, 20, "WORLD MAP - M or ESC to close");
	break;
}

/// The map fades when hidden; it only draws in gameplay or the map view.
var _map_x = 8;
var _map_y = _gui_h * 0.5 - 128;
var _map_w = 256;
var _map_h = 256;
var _map_enabled = MENU_VIEW == MENU_VIEW_GAME || MENU_VIEW == MENU_VIEW_MAP;
if(MENU_VIEW == MENU_VIEW_MAP){
	_map_w = min(_gui_w - 48, _gui_h - 72);
	_map_h = _map_w;
	_map_x = (_gui_w - _map_w) * 0.5;
	_map_y = (_gui_h - _map_h) * 0.5;
}
map.draw(spr_map_bg, spr_map_walls, _map_x, _map_y, _map_w, _map_h, _map_enabled);

/// Skill tree fades in and out independently of menu input.
eval_skill();

if(MENU_VIEW == MENU_VIEW_GAME || MENU_VIEW == MENU_VIEW_INVENTORY){
	scr_draw_tooltip(TOOLTIPS, _gui_w - 20, _gui_h - 90, 1);
}
scr_draw_reset();
