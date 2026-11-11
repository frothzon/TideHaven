/// @description update

// Keep custom area markers in front of generated ground tile layers.
var _area_marker = (variable_instance_exists(id, "dungeon_gate") && dungeon_gate)
	|| (variable_instance_exists(id, "dungeon_exit") && dungeon_exit)
	|| (variable_instance_exists(id, "dungeon_shrine") && dungeon_shrine)
	|| (variable_instance_exists(id, "dungeon_sign") && dungeon_sign)
	|| (variable_instance_exists(id, "tidehaven_guide") && tidehaven_guide);
if(_area_marker) depth = -1000;
else scr_set_depth(bbox_bottom);

in_range = false;
has_key = false;
var obj = instance_nearest(x,y,obj_player);
if(scr_check_instance(obj)){
	var _interaction_range = sprite_width * 0.8;
	if(variable_instance_exists(id, "interaction_range")) _interaction_range = interaction_range;
	in_range = point_in_circle(x,y,obj.x,obj.y,_interaction_range);
}

if(variable_instance_exists(id, "dungeon_gate") && dungeon_gate){
	if(state == 0 && in_range && keyboard_check_pressed(KEY_EQUIP)) scr_enter_dungeon();
	exit;
}

if(variable_instance_exists(id, "dungeon_exit") && dungeon_exit){
	if(state == 0 && in_range && keyboard_check_pressed(KEY_EQUIP)) scr_return_to_overworld();
	exit;
}

if(variable_instance_exists(id, "dungeon_shrine") && dungeon_shrine){
	if(state == 1){
		if(!oText.visible && array_length(oText.message) == 0) state = 0;
		else exit;
	}
	if(state == 0 && in_range && keyboard_check_pressed(KEY_EQUIP)){
		if(scr_claim_dungeon_shrine()){
			scr_showMessage("The Tide Shrine grants two healing potions and 15 experience.", 0, ["ok"]);
		} else if(global.CONFIG.shrine_claimed){
			scr_showMessage("The Tide Shrine has already given its reward.", 0, ["ok"]);
		} else {
			scr_showMessage("Make room for the shrine's reward and try again.", 0, ["ok"]);
		}
		state = 1;
	}
	exit;
}

if(state == 0){
	var chatstart = keyboard_check(KEY_EQUIP);
	if(variable_instance_exists(id, "tidehaven_guide") && tidehaven_guide) chatstart = keyboard_check_pressed(KEY_EQUIP);
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
