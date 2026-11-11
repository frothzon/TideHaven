// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_setup_statvars(_hp, _dmg, _spd, _stam=0){
	life = scr_set_statvar(_hp, STAT_LIFE);
	damage = scr_set_statvar(_dmg, STAT_DAMAGE);
	spd = scr_set_statvar(_spd, STAT_SPEED);
	stamina = scr_set_statvar(_stam, STAT_ENERGY);
	
	/// load
	life.import(STAT_DATA.life);
	damage.import(STAT_DATA.damage);
	spd.import(STAT_DATA.spd);
	
	take_damage = function(dmg){
		/// player damage -- has blocking ability
		if(variable_instance_exists(id,"_SM_")){
			var can_block = scr_get_state_index() == STATE.block;
			var block = 0;
			if(can_block){
				dmg *= (0.8 - PLAYER_SKILLS.shield2);
				block = random(1) < (0.15 + PLAYER_SKILLS.shield1);
				show_debug_message($"dmg reduce {(0.9 - PLAYER_SKILLS.shield2)}\nBlock chance {(0.2 + PLAYER_SKILLS.shield1)}");
			}
			if(!block){
				life.value -= dmg;
				scr_switch_state(STATE.hurt);
				return dmg;
			} else {
				/// play hit animation
				image_speed = 1;
				scr_play_sound(snd_whack2, 0);
				return -1;
			}
		} else {
			life.value -= dmg;
			return dmg;
		}
		return 0;
	}
}

/// used for items
function scr_stats_class(_hp, _dmg, _spd) constructor{
	life = _hp;
	damage = _dmg;
	spd = _spd;
}
