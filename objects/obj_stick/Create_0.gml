/// @description setup

damage_matrix = scr_setup_dmg_matrix(0,0,1);

image_xscale = 0.75;
image_yscale = 0.75;

/// properties
cooldown = 0;
break_distance = 16;
rotation = 45;
rotation_start = -100;
rotation_end = 45;
cooldown_max = 30;

/// selector
selector_inst = noone;
selector_frame = 0;
selector_count = sprite_get_number(spr_selector);

on_fire = false;
life = room_speed * 30;