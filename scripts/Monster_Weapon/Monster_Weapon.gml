// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Monster_Weapon(_damage, _rate, _range, _effect=-4) constructor{
	damage = _damage;	// attack damage
	rate = _rate;		// attack speed
	range = _range;		// attack range
	effect = _effect;	// effect object
	
	static in_range = function(xst, yst, target){
		return (point_distance(xst, yst, target.x, target.y) < self.range);
	}
	
	static attack = function(xst, yst, target){
		
		if(effect >= 0){
			var _eff = instance_create_depth(xst, yst, 0, self.effect);
			_eff.damage = self.damage;
			_eff.target = target;
		} else {
			/// instant damage to target
			scr_play_sound(snd_whack3, false);
			scr_play_sound(snd_smash, false);
			if(variable_instance_exists(target, "life")){
				// damage to player
				var _hit = target.take_damage(self.damage);
				var _show = $"-{_hit}";
				if(_hit == -1){
					_show = "Blocked!";
					scr_show_text_float(target.x, target.bbox_top, _show, c_white);
				} else {
					scr_show_text_float(target.x, target.bbox_top, _show, c_red);
				}
			} else {
				// damage to another instance
				target.stats.life.add(-self.damage);
				scr_show_text_float(target.x, target.bbox_top, -self.damage, c_red);
				with(target){
					scr_switch_state(STATE_MON.hurt);
				}
			}
		}
		
		return room_speed / rate;
	}
}