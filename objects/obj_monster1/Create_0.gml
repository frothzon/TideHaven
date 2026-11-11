/// @description set size

// Inherit the parent event
event_inherited();

damage_matrix = scr_setup_dmg_matrix(0,0,1);

hit_timer = 0;
jump_timer = room_speed;
xmove = x;
ymove = y;
move_vec = new scr_vec2_class();

/// get the open tile locations from position list
free_slots = []
var slot_radius = 64;

/// generate safe places to move nearby
for(var i = 0; i < 20; i++){
	var xx = xstart + irandom_range(-slot_radius, slot_radius);
	var yy = xstart + irandom_range(-slot_radius, slot_radius);
	if(!scr_tile_at_position(xx,yy,"GroundBase")){
		continue;
	}
	array_push(free_slots, [xx,yy]);
}

/// get unstuck if possible
wander_time = 0;
wander_timeout = room_speed * 3;

/// get sprite
sprite_list = CREATURE_SPRITES[WORLD_INDEX];
name = CREATURE_NAMES[WORLD_INDEX];

/// get shader ready
scr_ini_mon_outline(sprite_list[0]);