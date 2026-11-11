// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function tilemap_add_auto_tile(layer_name = "GroundAbove", tile_gen_obj, tile_check_index = 1, _depth = 0){
	var lay_id = layer_get_id(layer_name);
	var map_id = layer_tilemap_get_id(lay_id);
	var _w = tilemap_get_width(map_id);
	var _h = tilemap_get_height(map_id);
	
	for(var i = 0; i < _w; i++){
		for(var j = 0; j < _h; j++){
			var img = 0;
			if(tilemap_get(map_id, i, j) == tile_check_index){
				// get tile index by checking if it is next to similar tiles
				img += tilemap_get(map_id, i+1, j) == tile_check_index;		/// right
				img += 2*(tilemap_get(map_id, i, j-1) == tile_check_index);	/// up
				img += 4*(tilemap_get(map_id, i-1, j) == tile_check_index);	/// left
				img += 8*(tilemap_get(map_id, i, j+1) == tile_check_index);	/// down
				tile_gen_obj.add_tile(i*16, j*16, img, _depth);
			}
		}
	}
}