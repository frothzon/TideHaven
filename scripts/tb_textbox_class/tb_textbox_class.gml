// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function tb_textbox_class(_messages=[]) constructor{
	line = 0;
	char_index = 0;
	messages = _messages;
	talking = false;
	can_talk = true;
	on_gui = true;
	xdraw = 0;
	ydraw = 0;
	static has_message = function(){
		return array_length(self.messages);
	};
	static play_message = function(str=""){
		if(string_length(str) > 0){
			array_push(self.messages, str);
		}
		self.char_index = 0;
		self.talking = true;
	};
	static push_message = function(str){
		array_push(self.messages, str);
	};
	static update = function(){
		self.can_talk = true;
		var totalMessages = array_length(self.messages);
		if(totalMessages == 0) {
			self.can_talk = false;
			return 0;
		}
		
		if(self.talking){
			/// run dialogue
			var strSize = string_length(self.messages[self.line]);
			
			/// increment
			if(self.char_index < strSize){
				self.char_index++;	
			} else if(mouse_check_button_pressed(mb_left) || keyboard_check(KEY_EQUIP)){
				/// go to next message
				if(self.line != totalMessages-1){
					self.line++;
					self.char_index = 0;
				} else {
					/// clear messages out
					self.messages = [];
					self.talking = false;
				}
			}
			
		} else {
			self.line = 0;
			self.char_index = 0;
		}
		return totalMessages;
	};
	
	static draw = function(){
		if(!self.can_talk || !self.talking || !self.has_message()) {
			return 0;
		}
		var aX = (other.bbox_left + other.bbox_right) * 0.5;
		var aY = other.bbox_bottom - (other.sprite_height + 8);
		/// convert to gui coordinates
		if(on_gui){
			aX -= camera_get_view_x(view_camera[0]);
			aY -= camera_get_view_y(view_camera[0]);
			var _ww = camera_get_view_width(view_camera[0]);
			var _hh = camera_get_view_height(view_camera[0]);
			var _wto = display_get_gui_width();
			var _hto = display_get_gui_height();
			aX *= _wto / _ww;
			aY *= _hto / _hh;
		}
		self.xdraw = aX;
		self.ydraw = aY;
		tb_draw_textbox(self.xdraw, self.ydraw, messages[line], char_index);	
		return 1;
	}
}