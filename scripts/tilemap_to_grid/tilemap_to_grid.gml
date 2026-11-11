// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function tilemap_to_grid(layer_name = "GroundAbove"){
	var lay_id = layer_get_id(layer_name);
	var map_id = layer_tilemap_get_id(lay_id);
	var _w = tilemap_get_width(map_id);
	var _h = tilemap_get_height(map_id);
	var _grid = ds_grid_create(_w, _h);
	
	ds_grid_clear(_grid, 0);
	
	for(var i = 0; i < _w; i++){
		for(var j = 0; j < _h; j++){
			ds_grid_set(_grid, i, j, tilemap_get(map_id, i, j));
		}
	}
	
	return(_grid);
}