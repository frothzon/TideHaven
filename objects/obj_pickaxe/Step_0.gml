/// @description update

tool.item = scr_bag_get_item(PLAYER_GEAR, _GEAR_.weapon);

if(!is_struct(tool.item)){
	exit;	
}

if(GAME_PAUSED || BAG_PAUSED) exit;

var tool_type = tool.item.tool_type;
var rotate_default = 45;
var rotate_swing = -80;

/// custom tool behavior
var target = obj_targetable_parent;
var mask = 7;
switch(tool_type){
	case _TOOL_.shovel: 
		mask = 8;
		rotate_default = -90;
		rotate_swing = 100;
		break;
	case _TOOL_.pickaxe:
		mask = _MASK_.rocky;
	break;
	case _TOOL_.axe:
		mask = _MASK_.wooden;
	break;
	case _TOOL_.sword:
		mask = _MASK_.fleshy;
		rotate_default = 45;
		rotate_swing = -110;
	break;
}

rotation = lerp(rotation, rotate_default, 0.1);

image_angle = rotation * mirror;

var _mousePress = mouse_check_button(mb_left);

var _all = ds_list_create();
instance_position_list(mouse_x, mouse_y, target, _all, 1);
var _breakable = noone;
for(var i = 0; i < ds_list_size(_all); i++){
	// find first match
	var _obj = _all[| i];
	if(_obj.hit_mask & mask){
		_breakable = _obj;
		break;
	}
}

//if(keyboard_check_direct(KEY_EQUIP) && !scr_check_instance(_breakable)) _breakable = instance_position(mouse_x,mouse_y,obj_floor_parent);

with(_breakable){
	
	var _dist = distance_to_object(obj_player);
	
	if(_dist < other.break_distance){
		
		other.selector_inst = id;
		
		if(other.cooldown == 0 && _mousePress && !obj_player.held_shield && obj_player.stamina.value >= 1){
			life.value -= obj_player.damage.value;
			scr_show_text_float(x, bbox_top, -obj_player.damage.value, c_yellow);
			
			/// life steal
			if(PLAYER_SKILLS.steal > 0){
				var amt = PLAYER_SKILLS.steal * obj_player.damage.value;
				obj_player.life.add(amt);
			}
			
			/// effect
			var ratio = clamp(sprite_height/64, 0, 2);
			scaling.x = lerp(1.5, 1.15, ratio);
			scaling.y = lerp(0.5, 0.85, ratio);
			image_blend = c_red;
			
			/// sound
			var snd = scr_play_sound(snd_on_hit, 0);
			audio_sound_pitch(snd, random_range(0.8, 1.2));
			
			other.rotation = rotate_swing;
			other.cooldown = 30;
			obj_player.stamina.add(-1);
		}
	}
}


if(cooldown > 0) cooldown--;