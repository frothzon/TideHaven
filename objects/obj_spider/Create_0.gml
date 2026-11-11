/// @description setup

// Inherit the parent event
event_inherited();

stats = new Creature(5, 5, 1.25, 60, 1,
	[spider_run_anim_all_dir, spider_hit_anim_all_dir, spider_run_anim_all_dir, spider_death_anim_all_dir, spider_idle_anim_all_dir],
	[new Monster_Weapon(10, 0.5, 24)],[1]
);

life = stats.life;
destroy_sound = snd_death;
