/// @description update player

/// update player state machine
// World generation runs during room creation, which may happen before this player instance exists.
// Ensure the guide and cave entrance once both the world grid and player are available.
if(CURRENT_AREA == AREA_OVERWORLD && !global.CONFIG.overworld_guide_ready) scr_ensure_overworld_guide();

if(!BAG_PAUSED && !GAME_PAUSED && !show_skills){
	held_shield = false;
	switch(scr_get_state_index()){
		case STATE.def:
			scr_state_move_player();
			scr_default_animations();
			
			/// change to shield
			var _shield = scr_bag_get_item(PLAYER_GEAR, _GEAR_.shield);
			if(keyboard_check(KEY_FORCE) && !is_climbing && is_struct(_shield)){
				scr_switch_state(STATE.block);
			}
		break;
		case STATE.hurt:
			if(scr_state_startup()){
				scr_play_sound(snd_hurt, 0);	
			}
			scr_hurt_animation();
			scr_state_move_player();
			if(scr_get_state_time() > 0.5){
				scr_switch_state(STATE.def);
			}
		break;
		case STATE.block:
			/// default
			held_shield = true;
			if(scr_state_startup()){
				image_speed = 0;	
				image_index = 0;
			}
			/// reset
			if(image_index >= image_number-1){
				image_speed = 0;
				image_index = 0;
			}
			scr_get_keyboard_movement_vec(key_vector);
			scr_shield_animation();
			if(!keyboard_check(KEY_FORCE) || is_climbing){
				scr_switch_state(STATE.def);
			}
		break;
	}

	/// update timer on state machine
	scr_update_state_timer();

	/// update animation
	scr_animate_player(key_vector);

	/// udpate death
	scr_set_depth();

	/// update item
	scr_update_item();
	
	/// update exp
	if(STAT_EXP.value > STAT_EXP.max_value){
		STAT_EXP.max_value *= 2;
		STAT_EXP.value = 0;
		STAT_POINTS++;
		STAT_LEVEL++;
		scr_play_sound(snd_levelup, 0);
	}
	
	textbox.update();
	
	/// life regeneration
	if(regen_timer++ > room_speed){
		regen_timer = 0;
		if(PLAYER_SKILLS.regen > 0){
			var amt = life.max_value * PLAYER_SKILLS.regen;
			show_debug_message("Life ", amt);
			life.add(amt);
		}
	}
}
