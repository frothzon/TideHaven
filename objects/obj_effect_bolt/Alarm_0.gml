/// @description aquire target position just once

var nearest = instance_nearest(x,y,target);
if(scr_check_instance(nearest)){
	var dx = target.xprevious-target.x;
	var dy = target.yprevious-target.y;
	target_pos.x = nearest.x + dx;
	target_pos.y = nearest.y + dy;
}
