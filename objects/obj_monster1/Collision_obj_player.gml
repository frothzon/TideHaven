/// @description move outside

if(hit_timer <= 0) {
	other.life.value--;
	with(other){
		scr_switch_state(STATE.hurt);
	}
	hit_timer = room_speed * 0.5;
}
scr_collide_move();