/// @description setup

image_xscale = 0.75;
image_yscale = 0.75;
hook = {
	xprevious: x,
	yprevious: y,
	x: x,
	y: y
}

/// properties
cooldown = 0;
cooldown_max = 20;
hold_distance = 5;

/// hookshot vars
length = 0;
length_max = 200;
move_speed = 8;

/// list of things that can be grappled
grapple_objects = [obj_tree, obj_treasure, obj_fire_pit];

/// list of things that can be grabbed
grab_object = noone;

state = 0;
