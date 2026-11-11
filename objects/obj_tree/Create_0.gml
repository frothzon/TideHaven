/// @description pick sprite

// Inherit the parent event
event_inherited();

image_speed = 0;
image_index = irandom(image_number-1);
image_xscale *= choose(-1, 1);