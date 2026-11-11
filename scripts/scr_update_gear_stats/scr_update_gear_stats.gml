// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_update_gear_stats(){
	var life_current = obj_player.life.value;
	
	scr_reset_statvar(obj_player.damage);
	scr_reset_statvar(obj_player.life);
	scr_reset_statvar(obj_player.spd);
	var len = array_length(PLAYER_GEAR.items);
	for(var i = 0; i < len; i++){
		var _gear = PLAYER_GEAR.items[i];
		if(is_struct(_gear)){
			var _stats = is_array(_gear.data) ? _gear.data : [_gear.data];
			var _names = is_array(_gear.data_type) ? _gear.data_type : [_gear.data_type];
			var _len = array_length(_stats);
			/// loop through each set of stats and change player stats
			for(var j = 0; j < _len; j++){
				switch(_names[j]){
					case STAT_DAMAGE: scr_change_statvar(obj_player.damage, _stats[j], 1); break;
					case STAT_SPEED: scr_change_statvar(obj_player.spd, _stats[j], 1); break;
					case STAT_LIFE: scr_change_statvar(obj_player.life, _stats[j], 1); break;
				}
			}
		}
	}
	
	/// restore life
	obj_player.life.value = clamp(life_current, 0, obj_player.life.max_value);
}