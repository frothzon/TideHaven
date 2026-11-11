/// @description draw

var inst = instance_find(obj_player, 0);
var yy = y;
var xx = x;
var spr = sprite_index;
var ind = image_index;
var angle = image_angle;
var xsc = image_xscale;
var ysc = image_yscale;
/*
tool = {
	sprite: spr_gear,
	index: 5,
	offset: 45
}
*/

if(is_struct(tool.item)){
	image_angle += tool.offset;
	sprite_index = tool.item.sprite;
	image_index = tool.item.index;
} else {
	exit;	
}

/// move weapon with player
if(scr_check_instance(inst)){
	var frame = (inst.image_index % 6) / 6 * 360;
	if(inst.key_vector.length() == 0){
		y += lengthdir_y(0.75, frame);
	} else {
		if(inst.key_vector.x != 0){
			x -= lengthdir_y(0.75, frame) * sign(inst.key_vector.x);
			flip = false;
			if(sign(inst.key_vector.x) < 0){
				flip = true;	
			}
			
		} else if(inst.key_vector.y != 0){
			x -= lengthdir_y(0.5, frame) * sign(inst.key_vector.y);
			y -= lengthdir_y(0.25, frame) * sign(inst.key_vector.y);
		}
	}
}

/// keep tool facing correct direction
if(flip){
	image_xscale = abs(image_xscale);
	image_yscale = -abs(image_yscale);
	image_angle += 90;
} else {
	image_xscale = abs(image_xscale);
	image_yscale = abs(image_yscale);
}


draw_self();
y = yy;
x = xx;
sprite_index = spr;
image_index = ind;
image_angle = angle;
image_xscale = xsc;
image_yscale = ysc;