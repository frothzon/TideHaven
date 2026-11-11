// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function tb_draw_textbox(_xto, _yto, _string, _characters, _maxW=128, _outline=c_black, _hasBox=true){
	
	var sprArrow = sArrow;
	var sprBox = sTextbox;
	
	/// string properties
	var str = string_copy(_string, 1, _characters);
	var strW = string_width_ext(_string, -1, _maxW);
	var strH = string_height_ext(_string, -1, _maxW);
	
	/// Arrow
	var aX = _xto;
	var aY = _yto;
	
	/// Textbox
	var margin = 8;
	
	var tbW = strW + margin * 2;
	var tbH = strH + margin * 2;
	
	var tbX = aX - tbW/2;
	var tbY = aY - tbH;
	
	/// ascii converter
	static ascii_convert = function(_char){
		var _val = ord(string_lower(_char));
		var _a = ord("a");
		var _f = ord("f");
		var _0 = ord("0");
		var _9 = ord("9");
		if(_val >= _a && _val <= _f){
			return (10 + (_val-_a));	
		} else if(_val >= _0 && _val <= _9){
			return (_val - _0);
		}
		return 0;
	}
	
	if(_hasBox){
		
		/// Draw Arrow
		draw_sprite(sprArrow, 0, aX, aY);
	
		/// draw textbox
		draw_sprite_stretched(sprBox, 0, tbX, tbY, tbW, tbH);
	}
	
	/// draw text
	var len = string_length(str);
	var xdraw = tbX + margin;
	var ydraw = tbY + margin;
	var cmd = -1;
	var width = 0;
	var height = 0;
	var last_space = -1;
	var xjump = 0;
	var yjump = 0;
	var state = 0;
	
	if(len < 1) return;
	
	draw_set_color(c_white);
	var color_last = c_white;
	
	for(var i = 0; i < len; i++){
		var char = string_char_at(str, i+1);
		/// set command mode
		if(char == "#"){
			/// get command char
			char = string_char_at(str, i+2);
			/// select command
			switch(char){
				case "r": draw_set_color(c_red); break;
				case "g": draw_set_color(c_green); break;
				case "b": draw_set_color(c_blue); break;
				case "k": draw_set_color(c_black);break;
				case "w": draw_set_color(c_white);break;
				case "y" : draw_set_color(c_yellow); break;
				case "o" : draw_set_color(c_orange); break;
				case "p" : draw_set_color(c_purple); break;
				case "x" : draw_set_color(c_ltgray); break;
				case "l" : draw_set_color(c_lime); break;
				case "0": state = 0; break;
				case "1": state = 1; break;
				case "2": state = 2; break;
				case "3": state = 3; break;
				case "4": state = 4; break;
				case "5": state = 5; break;
			}
			/// hex colors
			if(char == "h"){
				var color = make_color_rgb(
					ascii_convert(string_char_at(str, i+3)) * 16,
					ascii_convert(string_char_at(str, i+4)) * 16,
					ascii_convert(string_char_at(str, i+5)) * 16
				);
				draw_set_color(color);
				i += 3;
			}
			
			color_last = draw_get_color();
			
			/// move past command to continue drawing
			char = string_char_at(str, i+3);
			i += 1;
			continue;
		} else if(char == "\n"){
			width = 0;
			height += string_height("H");
			continue;
		}
		
		draw_set_color(color_last);
		
		/// effects
		if(state == 0){
			// default
			xjump = 0;
			yjump = 0;
		} else if(state == 1){
			xjump = irandom_range(-1,1);
			yjump = irandom_range(-1,1);
		} else if(state == 2){
			yjump = scr_wave(-1.5,1.5,0.5,i*pi/4);
			xjump = 0;
		/// rainbow
		} else if(state == 3){
			draw_set_color(make_color_hsv(scr_wave(0, 255, 5, i*pi/64), 255, 255));	
		}
		/// gold
		else if(state == 4){
			var ratio = scr_wave(0, 1, 2, i*pi/64);
			var color = merge_color(c_orange, #ffff66, ratio);
			draw_set_color(color);	
		}
		/// hilight
		else if(state == 5){
			var ratio = scr_wave(0, 1, 3, i*pi/64);
			var color = merge_color(c_lime, c_green, ratio);
			draw_set_color(color);	
		}
		
		/// draw text
		scr_draw_text_outline(xdraw + width + xjump, ydraw + height + yjump, char, _outline, draw_get_color(), 1);
		//draw_text(xdraw + width + xjump, ydraw + height + yjump, char);
		
		/// get position
		width += string_width(char);
		
		/// test for overlap, and wrap around
		if(_maxW != -1){
			if(char == " "){
				var ww = width;
				for(var s = i+1; s < len; s++){
					var cnext = string_char_at(str, s+1);
					ww += string_width(cnext)
					if(cnext == " ") {
						s = len;
					} else if(ww > strW){
						/// wrap around
						width = 0;
						height += string_height("H");
						s = len;
					}
				}
			}
			/// forced wrap around
			if(width > strW){
				scr_draw_text_outline(xdraw + width + string_width("H"), ydraw + height + yjump, char, _outline, draw_get_color(), 1);
				//draw_text(xdraw + width + string_width("H"), ydraw + height, "-");
				width = 0;
				height += string_height("H");
			}
		}
		
	}
	draw_set_color(c_white);
	//draw_set_color(c_black);
	//draw_text_ext(tbX + margin, tbY + margin, str, -1, strW);
	//draw_set_color(c_white);
	
}