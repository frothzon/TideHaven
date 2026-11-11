/// @description update

if(GAME_PAUSED || BAG_PAUSED) exit;

var ratio = (cooldown_max-cooldown)/cooldown_max;

rotation = twerp(TwerpType.inout_circle, rotation_start, rotation_end, ratio);

image_angle = rotation * obj_player.image_xscale;

var _mousePress = mouse_check_button(mb_left);

var _breakable = instance_position(mouse_x, mouse_y, obj_fire_pit);

if(keyboard_check_direct(KEY_FORCE) && !scr_check_instance(_breakable)) _breakable = instance_position(mouse_x,mouse_y,obj_floor_parent);

with(_breakable){
	
	var _dist = distance_to_object(obj_player);
	
	if(_dist < other.break_distance){
		
		other.selector_inst = id;
		
		if(other.cooldown <= 0 && _mousePress){
			
			scr_play_sound(snd_hit_wood);
			if(on_fire){
				other.on_fire = true;	
			} else if(other.on_fire){
				on_fire = true;	
			}
			
			other.cooldown = other.cooldown_max;
		}
	}
}

if(!scr_check_instance(_breakable) && _mousePress && cooldown <= 0){
	other.cooldown = cooldown_max;
}


if(cooldown > 0) {
	cooldown--;
}

/// fire particles
if(!visible) on_fire = false;


var part = PARTICLE_ENGINE.pFlame;
if(on_fire){
	
	var xx = x + lengthdir_x(17,image_angle+90);
	var yy = y + lengthdir_y(17,image_angle+90);
	burst_particle(part,xx,yy,1,false);
	life--;
	if(life <= 0){
		for(var i = 0; i < 17; i+=1){
			var xx = x + lengthdir_x(i,image_angle+90);
			var yy = y + lengthdir_y(i,image_angle+90);
			burst_particle(part,xx,yy,1,false);
		}
		instance_destroy();
		scr_bag_add_item(PLAYER_BAG_TOOLS, TOOL_STICK, -1);
		obj_player.heldItem = noone;
	}
} else {
	life = room_speed * 30;	
}