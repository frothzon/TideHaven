// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function eval_skill(){
	var skill_desc = "";
	var _dw = display_get_gui_width();
	var _dh = display_get_gui_height();
	var skx = _dw * 0.5 - 250;
	var sky = _dh * 0.5 - 200;
	var rate = 0.1;
	
	if(show_skills){
		skill_offset.x = lerp(skill_offset.x, skx, rate);
		skill_offset.y = lerp(skill_offset.y, sky, rate);
		skill_offset.alpha = lerp(skill_offset.alpha, 1, rate);
	} else {
		skill_offset.y = lerp(skill_offset.y, -500, rate);
		skill_offset.x = lerp(skill_offset.x, skx, rate);
		skill_offset.alpha = lerp(skill_offset.alpha, 0, rate);
	}

	if(skill_offset.alpha > 0){
		var pulse = scr_wave(0.6, 0.8, 3, 0);
		draw_sprite_tiled_ext(spr_backdrop_skills, 0, 0, 0, 1, 1, c_white, skill_offset.alpha * pulse);
		var pos = CAMERA.mouse_gui();
		for(var i = 0; i < array_length(skill_nodes); i++){
			var node = skill_nodes[i];
			var state = node.draw(pos[0], pos[1], skill_offset.x, skill_offset.y);
			if(state == 1){
				skill_desc = node.desc;	
			}
			if(state == 2 && STAT_POINTS > 0){
				
				/// modify node, decrement skill points
				node.add_point();
				STAT_POINTS--;
				
				/// add skill data for node into CONFIG
				if(is_struct(SKILL_DATA[i])){
					delete SKILL_DATA[i]
				}
				SKILL_DATA[i] = node.export();
			}
		}
		/// show desc
		if(skill_desc != ""){
			draw_set_font(fnt_hud_small);
			var offset = 16;
			var wt = 200;
			var ht = string_height_ext(skill_desc, -1, wt);
			var xmax = display_get_gui_width()-wt;
			var ymax = display_get_gui_height()-ht;
			var xt = clamp(pos[0]+offset, 0, xmax);
			var yt = clamp(pos[1]+offset, 0, ymax);
			draw_sprite_stretched(spr_tooltip, 0, xt-4, yt-4, string_width_ext(skill_desc, -1, wt) + 8, ht + 8);
			draw_text_outline_sdf_ext(fnt_hud_small, xt, yt, skill_desc, wt, c_black, c_white, 2);
		}
		/// show points
		var txt = STAT_POINTS <= 0 ? "No Points" : $"{STAT_POINTS} Points";
		var shift = scr_wave(0, 1, 1, 0);
		var colshift = merge_color(c_white, c_lime, shift);
		draw_set_font(fnt_hud_big);
		draw_set_alpha(skill_offset.alpha);
		draw_text_outline_sdf(fnt_hud_big, 16, 16, txt, c_black, colshift, 2);
		scr_draw_reset();
		
	}
}
