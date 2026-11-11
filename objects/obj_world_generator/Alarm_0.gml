/// @description auto spawning


instance_activate_all();

if(instance_number(obj_breakable_parent) < 100){
	auto_spawn(spawn_weight, spawn_objects);
	//scr_print("spawning...");
}

var nums = instance_number(obj_breakable_parent);
if(nums < 20){
	alarm[0] = room_speed;
} else if(nums < 40){
	alarm[0] = room_speed * 5;
} else if(nums < 100){
	alarm[0] = room_speed * 10;
} else {
	alarm[0] = room_speed * 30;
}
scr_disable_outside_view(CAMERA, obj_wall);
scr_disable_outside_view(CAMERA, obj_respawn);