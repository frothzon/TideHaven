// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sm_monster_wander(){
	if(scr_state_startup()){
		/// initialization code (only runs on state start)
	}
	
	/// distance to player
	var dis = player_distance;
	
	/// update movement vector
	var spd = scr_monster_get_vector(xmove, ymove, stats.move_speed);
	
	if(point_distance(x, y, xmove, ymove) > 0){
		var face_dir = point_direction(x,y,xmove,ymove);
		angle_last = scr_rotate_smooth(angle_last, face_dir, 10);
	}
	
	if(speed_vec.length() > 0.05){
		set_sprite_rotation(stats.sprite_walk, angle_last);
	} else {
		set_sprite_rotation(stats.sprite_idle, angle_last);
	}
	
	if(wander_time > wander_timeout){
		var halfRange = wander_range / 2;
		xmove = xstart + irandom_range(-halfRange, halfRange);
		ymove = ystart + irandom_range(-halfRange, halfRange);
		wander_time = 0;
		show_debug_message($"Pick spot {xmove}, {ymove}");
	} else {
		wander_time++;	
	}
	
	if(dis < stats.chase_range - 4){
		/// go to chase state
		if(stats.life.value > stats.low_hp){
			scr_switch_state(STATE_MON.chase);
		} else {
		/// go to run state	
			scr_switch_state(STATE_MON.run);
		}
	}
}