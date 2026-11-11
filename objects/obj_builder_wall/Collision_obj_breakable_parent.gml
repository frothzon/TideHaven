/// @description skip collisions

// Inherit the parent event
if(variable_instance_exists(other, "mode")){
	if(mode != 0 && other.mode != 0){
		event_inherited();
	}
} else {
	event_inherited();
}