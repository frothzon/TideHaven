// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Skill(_name, _image, _x, _y, _locked=1, _start=0, _max=1) constructor{
	name = _name;
	image = _image;
	desc = "Click on it to assign points";
	x = _x;
	y = _y;
	w = 80;
	h = 64;
	color = #ddff00;
	text_color = c_orange;
	locked = _locked;
	points = _start;
	full = _max;
	icon_index = -1;
	children = [];
	font = fnt_hud_small;
	
	on_increment = function(node){};
	
	/// for saving data
	static export = function(){
		var _data = {
			points,
			locked
		};
		return _data;
	};
	
	/// for loading data
	static import = function(_data){
		if(is_struct(_data)){
			points = _data.points;
			locked = _data.locked;
		}
	};

	static add_child = function(node){
		array_push(self.children, node);
	};
	
	static add_point = function(){
		if(!self.locked && self.points < self.full){
			self.points++;
			on_increment(self);
			scr_play_sound(snd_UI_Synth_01, false);
			
			/// unlock children
			for(var i = 0; i < array_length(self.children); i++){
				self.children[i].locked = false;	
			}
		}
	};
	
	static draw = function(mx, my, ox=0, oy=0){
		var _state = 0;
		var _xx = self.x + ox;
		var _yy = self.y + oy;
		if(point_in_rectangle(mx, my, _xx, _yy, _xx + self.w, _yy + self.h)){
			_state = 1;
			if(mouse_check_button_pressed(mb_left)){
				_state = 2;
			}
		}
		/// draw line to children
		var x1 = _xx + self.w/2;
		var y1 = _yy + self.h/2;
		for(var i = 0; i < array_length(self.children); i++){
			var child = self.children[i];
			var x2 = child.x + ox + child.w/2;
			var y2 = child.y + oy + child.h/2;
			draw_set_color(c_black);
			draw_line_width(x1,y1,x2,y2,4);
			draw_set_color(c_white);
			draw_line_width(x1,y1,x2,y2,2);
		}
		
		// Clamp pressed state to the last frame so two-state node art stays valid.
		var _frame = clamp(_state, 0, sprite_get_number(self.image) - 1);
		draw_sprite_stretched_ext(self.image, _frame, _xx, _yy, self.w, self.h, self.locked ? c_white : self.color, 1);
		var _name_x = x1;
		if(self.icon_index >= 0 && self.icon_index < 9){
			// The dedicated sprite is a transparent 3x3 sheet, one icon per active skill.
			var _sheet_w = sprite_get_width(spr_skill_icon);
			var _sheet_h = sprite_get_height(spr_skill_icon);
			var _col = self.icon_index mod 3;
			var _row = floor(self.icon_index / 3);
			var _src_x = floor(_col * _sheet_w / 3);
			var _src_y = floor(_row * _sheet_h / 3);
			var _src_w = floor((_col + 1) * _sheet_w / 3) - _src_x;
			var _src_h = floor((_row + 1) * _sheet_h / 3) - _src_y;
			var _icon_tint = self.locked ? c_ltgray : c_white;
			var _icon_alpha = self.locked ? 0.85 : 1;
			draw_sprite_part_ext(spr_skill_icon, 0, _src_x, _src_y, _src_w, _src_h, _xx + 1, _yy + 19, 26 / _src_w, 26 / _src_h, _icon_tint, _icon_alpha);
			_name_x = _xx + 54;
		}
		
		draw_set_font(font);
		draw_set_halign(fa_center);
		draw_text_outline_sdf(font, _name_x, y1, self.name, c_black, self.locked ? c_white : self.text_color,2);
		draw_set_halign(fa_left);
		draw_set_font(font);
		var txt = self.locked? "Locked" : $"{self.points}/{self.full}";
		draw_text_outline_sdf(font, _xx+4, _yy, txt,c_black,c_white);
		scr_draw_reset();
		
		return _state;
	}
	
}
