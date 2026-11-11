// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_state_move_player(){
	
	//var xlast = x;
	//var ylast = y;
	
	/// calculate move vector based on key input
	scr_get_keyboard_movement_vec(key_vector);
	
	/// snap player to pixel grid when moving
	scr_snap_to_grid(key_vector);
	
	/// climbing
	//var _layer = layer_get_id("Climb");
	//var _tiles = layer_tilemap_get_id(_layer);
	is_climbing = false;//position_meeting(x, y, _tiles);
	
	/// move out of wall
	var _tiles = get_wall_tileset();
	move_and_collide(key_vector.x, key_vector.y, [obj_wall, obj_breakable_parent, _tiles]);
}