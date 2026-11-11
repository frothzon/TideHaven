// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Creature(hp, mp, spd, chase_dist, flee_hp, spr_list, wpn_list, wpn_weights) constructor{
	life = scr_set_statvar(hp);
	magic = scr_set_statvar(mp);
	/// sprites [walk, hurt, attack, die, idle]
	var expand = function(arr){
		if(!is_array(arr)){
			arr = [arr, arr, arr, arr];
		}
		return arr;
	}
	
	sprite_walk = expand(spr_list[0]);
	sprite_hurt = expand(spr_list[1]);
	sprite_attack = expand(spr_list[2]);
	sprite_die = expand(spr_list[3]);
	sprite_idle = expand(spr_list[4]);
	weapons = wpn_list;
	weights = wpn_weights;
	cooldown = 0;
	current_weapon = scr_random_weighted(wpn_weights);
	chase_range = chase_dist;
	move_speed = spd;
	low_hp = flee_hp;
	
	/// check if in range of weapon
	static in_range = function(src, target){
		var wpn = self.weapons[self.current_weapon];
		return wpn.in_range(src.x, src.y, target);
	}
	
	/// get range
	static get_range = function(){
		var wpn = self.weapons[self.current_weapon];
		return wpn.range;
	}
	
	/// try to attack
	static attack = function(src, target){
		if(self.in_range(src, target) && self.cooldown <=0){
			var wpn = self.weapons[self.current_weapon];
			var delay = wpn.attack(src.x, src.y, target);
			self.cooldown += delay;
			/// auto rotate weapon
			self.current_weapon = scr_random_weighted(self.weights);
			/// return damage done
			show_debug_message($"Monster attack dmg = {wpn.damage}");
			return wpn.damage;
		}
		return -1;
	}
}