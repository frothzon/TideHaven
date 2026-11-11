// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sm_monster_chase(){
	
	/// distance to player
	var dis = player_distance;
	var target = instance_nearest(x,y,obj_player);
	var in_range = stats.in_range(id, target);
	
	var angle = point_direction(target.x, target.y, x, y);
	var range = stats.get_range() - 8;
	
	var dx = lengthdir_x(range, angle);
	var dy = lengthdir_y(range, angle);
	
	/// update movement vector
	scr_monster_get_vector(target.x + dx, target.y + dy, stats.move_speed);
	
	/// always moving in chase mode
	angle_last = scr_rotate_smooth(angle_last, angle+180, 10);
	set_sprite_rotation(stats.sprite_walk, angle_last);
	
	if(dis > stats.chase_range){
		/// go to wander state
		scr_switch_state(STATE_MON.wander);
	}
	
	/// can attack
	if(in_range && stats.cooldown <= 0){
		scr_switch_state(STATE_MON.attack);
	}
}