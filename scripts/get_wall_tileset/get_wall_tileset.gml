// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_wall_tileset(){
	if(CURRENT_AREA == AREA_DUNGEON) return obj_wall;
	return perlin_world.map_walls;
}
