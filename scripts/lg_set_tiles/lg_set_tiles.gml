/// @desc lg_set_tiles(layer_name,ds_grid_id);
/// @param layer_name {string}
/// @param ds_grid_id {real}
function lg_set_tiles(argument0, argument1) {

	var _map_id = is_string(argument0) ? layer_get_id(argument0) : argument0;
	var	_wall_map_id = layer_tilemap_get_id(_map_id);
	var	grid_ = argument1;
	var	height_ = ds_grid_height(grid_);
	var	width_ = ds_grid_width(grid_);


	/// Loop through tilemap and swap tiles
	for (var _y = 1; _y < height_ -1; _y++) {
	    for (var _x = 1; _x < width_ -1; _x++) {
		    if(grid_[# _x, _y] != EMPTY){
				/// get tile data for tiles nearby
				var _north_tile = grid_[# _x, _y-1] == GROUND,	/// bool: if north tile is empty
					_east_tile = grid_[# _x+1, _y] == GROUND,		/// bool: if east tile empty
					_south_tile = grid_[# _x, _y+1] == GROUND,	/// bool: if south tile empty
					_west_tile = grid_[# _x-1, _y] == GROUND,		/// bool: if west tile empty
					_tile_index = lg_bitmask(_north_tile,_east_tile,_south_tile,_west_tile);
				/// set tiles
				if (_tile_index == 1){
					grid_[# _x, _y] = EMPTY;
				}
			}
		}
	}
	/// Loop through tilemap and set the tiles
	for (var _y = 1; _y < height_ -1; _y++) {
	    for (var _x = 1; _x < width_ -1; _x++) {
		    if(grid_[# _x, _y] != EMPTY){
				/// get tile data for tiles nearby
				var _north_tile = grid_[# _x, _y-1] == GROUND,	/// bool: if north tile is empty
					_east_tile = grid_[# _x+1, _y] == GROUND,		/// bool: if east tile empty
					_south_tile = grid_[# _x, _y+1] == GROUND,	/// bool: if south tile empty
					_west_tile = grid_[# _x-1, _y] == GROUND,		/// bool: if west tile empty
					_tile_index = lg_bitmask(_north_tile,_east_tile,_south_tile,_west_tile);
				/// set tiles
				tilemap_set(_wall_map_id, _tile_index, _x, _y);
			}
		}
	}



}
