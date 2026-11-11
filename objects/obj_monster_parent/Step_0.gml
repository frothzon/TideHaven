/// @description attack player

/*
	stats below:
	life = scr_set_statvar(hp);
	magic = scr_set_statvar(mp);
	/// sprites [walk, hurt, attack, die, idle]
	
	sprite_walk = spr_list[0];
	sprite_hurt = spr_list[1];
	sprite_attack = spr_list[2];
	sprite_die = spr_list[3];
	sprite_idle = spr_list[4];
	
	weapons = wpn_list;
	weights = wpn_weights;
	cooldown = 0;
	current_weapon = 0;
	
	/// randomly select weapon
	static change_weapon = function()
	/// check if in range of weapon
	static in_range = function(src, target)
	/// try to attack
	static attack = function(src, target)
*/

/// save distance
player_distance = distance_to_object(obj_player);

/// speed
speed_vec.lerp_to(move_vec, 0.2);

/// attack cooldown
if(stats.cooldown > 0) {
	stats.cooldown--;	
}

enum STATE_MON{
	wander,
	chase,
	run,
	attack,
	hurt
};

/// run states
var _state = scr_get_state_index();
switch(_state){
	case 0:
		/// state wander
		sm_monster_wander();
	
	break;
	case 1:
		/// state chase
		sm_monster_chase();

	break;
	case 2:
		/// state run
		sm_monster_run();
	
	break;
	case 3:
		/// attack
		sm_monster_attack();
	
	break;
	case 4:
		/// hurt
		sm_monster_hurt();
		
	break;
	case 5:
		/// death
		if(scr_state_startup()){
			/// initialization code (only runs on state start)
			set_sprite_rotation(stats.sprite_die, angle_last);
			image_index = 0;
			/// update movement vector
			move_vec.x = 0;
			move_vec.y = 0;
		}
		if(image_index >= image_number-1){
			instance_destroy();	
		}
	break;
}
scr_update_state_timer();

/// move out of wall
if(speed_vec.length() > 0){
	var _layer = layer_get_id("Walls");
	var _tiles = layer_tilemap_get_id(_layer);
	move_and_collide(speed_vec.x, speed_vec.y, [obj_wall, _tiles]);
}