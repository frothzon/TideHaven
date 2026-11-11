/// @description update

scr_set_depth();
if(GAME_PAUSED || BAG_PAUSED) exit;

var _mousePress = mouse_check_button(mb_left);
var _mouseDir = point_direction(x,y,mouse_x,mouse_y);

x = obj_player.x + lengthdir_x(hold_distance, image_angle);
y = obj_player.y + lengthdir_y(hold_distance, image_angle) - 4;

length = point_distance(x, y, hook.x, hook.y);

if(state == 2){
	// ensure we can't overshoot the hook and keep moving indefinitely
	image_angle	= point_direction(x, y, hook.x, hook.y);
}


var dx = lengthdir_x(move_speed, image_angle);
var dy = lengthdir_y(move_speed, image_angle);

switch(state){
	case 0:	// state -- idle
		image_angle = scr_rotate_smooth(image_angle, _mouseDir, 10);
		hook.xprevious = hook.x;
		hook.yprevious = hook.y;
		hook.x = x;
		hook.y = y;

		if(cooldown <= 0 && _mousePress){
			cooldown = cooldown_max;
			state = 1;
			scr_play_sound(snd_shoot_grapple, 0);
		}

		if(cooldown > 0) cooldown--;
	break;
	case 1: // state -- shoot
		hook.x += dx;
		hook.y += dy;
		
		/// checking objects we can grapple
		var hit = collision_line(hook.xprevious, hook.yprevious, hook.x, hook.y, obj_wall, 1, 0);
		if(scr_check_instance(hit)){
			var grapple = false;
			for(var i = 0; i < array_length(grapple_objects); i++){
				if(hit.object_index	== grapple_objects[i]){
					state = 2;
					grapple = true;
					scr_play_sound(snd_grab_grapple, 0, [hook.x, hook.y]);
				}
			}
			if(!grapple){
				/// hit wall
				scr_play_sound(snd_whack, 0, [hook.x, hook.y]);
				state = 3;
			}
			
		}
		/// grap object
		hit = collision_line(hook.xprevious, hook.yprevious, hook.x, hook.y, obj_collectible, 1, 0);
		if(scr_check_instance(hit)){
			grab_object = hit;
			state = 3;
			scr_play_sound(snd_drop, 0, [hook.x, hook.y]);
		}
		/// pull cord back
		if(length > length_max){
			grab_object = noone;
			state = 3;
		}
	break;
	case 2: // state -- pull player to object
		// move player along direction
		obj_player.x += dx;
		obj_player.y += dy;
		
		// when close or hit an object, exit grapple mode
		if(place_meeting(obj_player.x,obj_player.y,obj_wall) || length < 16){
			state = 0;
		}
	break;
	case 3: /// state -- pull object to player
		var dir = point_direction(x,y,hook.x, hook.y);
		image_angle = scr_rotate_smooth(image_angle, dir, 5);
		
		hook.x = lerp(hook.x, x, 0.25);
		hook.y = lerp(hook.y, y, 0.25);
		
		if(scr_check_instance(grab_object)){
			grab_object.x = hook.x;
			grab_object.y = hook.y;
		}
		if(length < 8){
			state = 0;
		}
	break;
}