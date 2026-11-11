// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function tilemap_add_grass(layer_name = "GroundAbove", grass_gen_obj){
	
	var lay_id = layer_get_id(layer_name);
	var map_id = layer_tilemap_get_id(lay_id);
	var _w = tilemap_get_width(map_id);
	var _h = tilemap_get_height(map_id);
	
	for(var i = 0; i < _w; i++){
		for(var j = 0; j < _h; j++){
			if(tilemap_get(map_id, i, j) == 1){
				grass_gen_obj.add_patch(i*16-8, j*16-8);
			}
		}
	}
}