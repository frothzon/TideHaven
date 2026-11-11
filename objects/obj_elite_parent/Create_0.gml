/// @description setup elite

// Inherit the parent event
event_inherited();

/// each spawn is a little stronger - keep it difficult
var hp_get = 25 + STAT_LEVEL * 5;
var dmg_get = 4 + STAT_LEVEL;

stats = new Creature(hp_get, 5, 1.25, 60, 1,
	[spider_run_anim_all_dir, spider_hit_anim_all_dir, spider_run_anim_all_dir, spider_death_anim_all_dir, spider_idle_anim_all_dir],
	[new Monster_Weapon(dmg_get, 0.5, 24)],[1]
);

life = stats.life;
exp_given = 15;