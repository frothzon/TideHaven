/// @description update

in_range = false;
has_key = false;
var obj = instance_nearest(x,y,obj_player);
if(scr_check_instance(obj)){
	in_range = point_in_circle(x,y,obj.x,obj.y,sprite_width * 0.8);
}
if(state == 0){
	var chatstart = keyboard_check(KEY_EQUIP);
	if(in_range){
		if(chatstart){
			//textbox = new tb_textbox_class();
			if(is_array(messages)){
				for(var i = 0; i < array_length(messages); i++){
					textbox.push_message(messages[i]);
				}
				textbox.play_message();
			} else {
				textbox.play_message(messages);
			}
			state = 1;
			timer = room_speed / 2;
		}
	}
} else if(state == 1){
	if(textbox.has_message() == 0 || !in_range){
		timer--;
		textbox.messages = [];
		if(timer <= 0){
			state = 0;
		}
	}
}

textbox.update();
