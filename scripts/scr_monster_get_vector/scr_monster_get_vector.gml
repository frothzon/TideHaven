// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// @param x
/// @param y
function scr_monster_get_vector(xto, yto, spd){
	move_vec.vector_from_points(x,y,xto, yto);
	var len = spd;
	move_vec.set_length(len);
	if(point_distance(x,y,xto,yto) <= 8){
		len = 0;
		move_vec.x = 0;
		move_vec.y = 0;
	}
	return len;
}