/// @description set size

// Inherit the parent event
event_inherited();

stats = new Creature(5, 5, 1.25, 60, 1,
	[spider_run_anim_all_dir, spider_hit_anim_all_dir, spider_run_anim_all_dir, spider_death_anim_all_dir, spider_idle_anim_all_dir],
	[new Monster_Weapon(5, 0.5, 24)],[1]
);

life = stats.life;
exp_given = 7;

hit_timer = 0;
xmove = x;
ymove = y;
move_vec = new scr_vec2_class();
speed_vec = new scr_vec2_class();

/// get unstuck if possible
wander_time = 0;
wander_timeout = room_speed * 3;
wander_range = 100;
player_distance = 1000;
angle_last = 0;
destroy_sound = snd_death;

scr_setup_state_machine();

//------------------------ states
