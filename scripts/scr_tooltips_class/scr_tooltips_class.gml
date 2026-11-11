// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_tooltips_class() constructor{
	list = [];
	timer = 0;
	size = 32;
	time_max = 2;
	back = spr_tooltip;
	static add_tooltip = function(_text, _image, _color, _ind=0){
		array_push(list,{text: _text, image: _image, color: _color, index: _ind});
	};
	static update = function(){
		var count = array_length(list);
		if(count > 0){
			var spd = clamp(array_length(list) / 2 + 1, 1, room_speed);
			timer += spd/room_speed;
			//show_debug_message(timer);
			if(timer > time_max){
				
				if(count > 9){
					while(array_length(list) > 9){
						array_delete(list, 0, 1);
					}
				} else array_delete(list, 0, 1);
				timer = 0;
			}
		}
	};
	static draw = function(xto, yto, align_right){
		var yy = yto;
		var xdraw = align_right ? xto - 4 : xto + size + 4;
		if(align_right) draw_set_halign(fa_right); else draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		for(var i = 0; i < array_length(list); i++){
			var item = list[i];
			
			var wtext = string_width(item.text);
			/// background
			draw_sprite_stretched(back, 0, xto - size*0.5 - wtext, yy - size * 0.5, wtext + size, size);
			
			/// draw image
			draw_sprite_stretched(item.image, item.index, xto - size*0.5, yy - size * 0.5, size, size);
			
			/// draw text
			scr_draw_text_outline(xdraw, yy, item.text, c_black, item.color);
			
			yy -= size;
			
		}
		draw_set_halign(fa_left);
		draw_set_valign(fa_bottom);
	}
}

function scr_add_tooltip(ttip, txt, img, ind, col){
	ttip.add_tooltip(txt, img, col, ind);
}

function scr_draw_tooltip(ttip, xto, yto, align_right){
	ttip.draw(xto, yto, align_right);
}

function scr_update_tooltip(ttip){
	ttip.update();
}
