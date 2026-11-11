/// @description move to player

var col = collision_circle(x,y,16,obj_player, 1, 0);
if(scr_check_instance(col)){
	move_towards_point(col.x, col.y, 4);	
}



