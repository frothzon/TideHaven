/// @description update

scr_set_depth();
if(GAME_PAUSED || BAG_PAUSED) exit;

var _mousePress = mouse_check_button(mb_left);
var _mouseDir = point_direction(x,y,mouse_x,mouse_y);

/*
/// properties
cooldown = 0;
cooldown_max = 20;

*/

hold_distance = lerp(hold_distance, hold_distance_clamp, 0.25);
image_angle = scr_rotate_smooth(image_angle, _mouseDir, 5);
x = obj_player.x + lengthdir_x(hold_distance, image_angle);
y = obj_player.y + lengthdir_y(hold_distance, image_angle) - 4;

if(cooldown <= 0 && _mousePress){
	cooldown = cooldown_max;
	hold_distance = 0;
	var _arrow = instance_create_depth(x,y,0,obj_arrow);
	_arrow.speed = 5;
	_arrow.direction = image_angle;
	_arrow.image_angle = image_angle;
	scr_play_sound(snd_shoot_bow, 0);
}


if(cooldown > 0) cooldown--;