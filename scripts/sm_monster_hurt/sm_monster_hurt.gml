// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sm_monster_hurt(){
	if(scr_state_startup()){
		/// initialization code (only runs on state start)
		set_sprite_rotation(stats.sprite_hurt, angle_last);
	}
	
	if(scr_get_state_time() > 1){
		/// return to default state
		scr_switch_state(STATE_MON.wander);
	}
}