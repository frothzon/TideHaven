// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sm_monster_attack(){
	
	/// distance to player
	/// distance to player
	var dis = player_distance;
	var target = instance_nearest(x,y,obj_player);
	
	/// stop if player not available
	if(!scr_check_instance(target)){
		scr_switch_state(0);
		return;
	}
	
	/// update movement vector
	move_vec.x = 0;
	move_vec.y = 0;
	
	if(scr_state_startup()){
		/// initialization code (only runs on state start)
		set_sprite_rotation(stats.sprite_attack, angle_last);
		
		/// perform attack
		var dmg = stats.attack(id, target);
	}
	
	
	/// return to wander
	if(scr_get_state_time() > 0.25){
		scr_switch_state(STATE_MON.wander);
	}
}