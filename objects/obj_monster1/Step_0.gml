/// @description attack player

if(hit_timer > 0) hit_timer--;
var dis = distance_to_object(obj_player);
if(dis < 50){
	image_speed = 1;
	scr_monster_get_vector(obj_player.x, obj_player.y);
} else {
	image_speed = 0.5;
	scr_monster_get_vector(xmove, ymove);
	if(point_distance(x,y,xmove,ymove) < 16 || wander_time > wander_timeout){
		var len = array_length(free_slots);
		var randpos = irandom(len-1);
		xmove = free_slots[randpos][0];
		ymove = free_slots[randpos][1];
		wander_time = 0;
	} else {
		wander_time++;	
	}
}

mp_potential_step_object(x+move_vec.x, y+move_vec.y, 1, obj_breakable_parent);

if(jump_timer > 0) {
	jump_timer--
} else {
	jump_timer = room_speed * irandom_range(1,2);
	zAxis.jump(5);
}