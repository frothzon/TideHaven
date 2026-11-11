/// @description setup life

scr_ini_breakable();
item = -1;
can_collide = room_speed;

enum _MASK_{
	wooden = 1,
	rocky = 2,
	fleshy = 4,
	ground = 8
}
hit_mask = 7;