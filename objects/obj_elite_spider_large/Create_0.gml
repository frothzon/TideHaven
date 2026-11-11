/// @description setup

// Inherit the parent event
event_inherited();


/// each spawn is a little stronger - keep it difficult
var hp_get = 50 + STAT_LEVEL * 10;
var dmg_get = 1.5 + STAT_LEVEL * 0.5;

stats = new Creature(hp_get, 5, 1.25, 60, 0,
	[
		/// walk sprites
		[spr_spider_walk_right, spr_spider_walk_up, spr_spider_walk_left, spr_spider_walk_down], 
		/// hurt
		[spr_spider_walk_right, spr_spider_walk_up, spr_spider_walk_left, spr_spider_walk_down], 
		/// attack
		[spr_spider_attack_right, spr_spider_attack_up, spr_spider_attack_left, spr_spider_attack_down], 
		/// die
		spr_spider_death, 
		/// idle
		[spr_spider_idle_right,spr_spider_idle_up,spr_spider_idle_left,spr_spider_idle_down]
	],
	[new Monster_Weapon(dmg_get, 0.75, 24), new Monster_Weapon(dmg_get * 10, 0.35, 40, obj_effect_bolt)],[5, 3]
);

life = stats.life;

exp_given = 25;

destroy_sound = snd_death;