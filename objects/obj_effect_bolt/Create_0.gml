/// @description setup

/*
	effect placed at source x,y
	expected to do damage to target
*/
damage = 10;
target = obj_player;
state = 0;
timer = 50;
timer_max = timer;
range = 15;
image_speed = 0;
image_index = 0;
alarm[0] = 1;
target_pos = {x: obj_player.x, y: obj_player.y};