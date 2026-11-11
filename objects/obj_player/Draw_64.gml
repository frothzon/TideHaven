/// @description draw level stuff

draw_set_font(fnt_hud_small);
if(BAG_PAUSED){
	/// draw stats	
	var str = scr_concat(life.toString(),"\n",damage.toString(),"\n",spd.toString(),"\n",stamina.toString());
	scr_draw_text_outline(16,32,str);
} else {
	
	if(!show_skills){
		draw_set_halign(fa_left);
	
		/// text / size
		var txt = scr_concat("LVL. ", STAT_LEVEL);
		var ww = string_width(txt);
		var wbar = 200;
		var xmid = display_get_gui_width()*0.5 - wbar*0.5 - ww;
	
		/// draw level
		scr_draw_text_outline(xmid,16,txt);
		scr_draw_bar(spr_exp_bar, xmid + ww + 24, 16, wbar, 16, STAT_EXP.ratio());
	
		/// draw points
		if(STAT_POINTS > 0){
			var val = scr_wave(0,1,.5,0);
			var col = merge_color(c_white, c_yellow, val);
			scr_draw_text_outline(16,64,scr_concat("Points: ", STAT_POINTS),,col);
		}
	
		/// hp
		scr_draw_text_outline(80, 16, string(STAT_LIFE));
		var life_bar = life.ratio();
		scr_draw_bar(spr_health_bar, 16,16,60,16,life_bar,c_red,c_lime);
		/// stm
		scr_draw_text_outline(80, 48, string(STAT_ENERGY));
		var stam_bar = stamina.ratio();
		scr_draw_bar(spr_health_bar, 16,48,60,16,stam_bar,c_purple,c_aqua);
		
	
		textbox.draw();
		
		/// draw map
		/// static draw = function(sprite_bg, sprite_cell, xto, yto, xcell, ycell)
		ww = 256;
		var hh = 256;
		var xto = 8;
		var yto = display_get_gui_height()/2 - hh/2;
		map.draw(spr_map_bg, spr_map_walls, xto, yto, ww, hh);
	}
	
	/// skill test
	eval_skill();
}

/// tooltips
scr_draw_tooltip(TOOLTIPS, display_get_gui_width()-20, display_get_gui_height()-90, 1);
scr_draw_reset();