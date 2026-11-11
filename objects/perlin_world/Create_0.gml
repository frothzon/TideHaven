/// @description Setup grid

/// setup music to loop through
music_list = [mus_adventure1, mus_adventure2, mus_adventure3, mus_adventure4];
music_playlist = array_shuffle(music_list);
music_playing = scr_play_music(array_pop(music_playlist), 0);
battle_music_playing = scr_play_music(mus_battle, 1);
audio_sound_gain(battle_music_playing, 0, 0);
audio_sound_gain(music_playing, 0, 0);
audio_sound_gain(music_playing, 1, 5000);


/// create my layers
var lay_sand = layer_create(layer_depth_above, "lay_sand");
var lay_dirt = layer_create(layer_depth_above-2, "lay_dirt");
var lay_grass = layer_create(layer_depth_above-4, "lay_grass");
var lay_id = layer_create(layer_depth_above-6, "lay_doodad");

/// walls -- can be used for collisions
var lay_walls = layer_create(layer_depth_above-7, "lay_walls");
if(!debug_mode){
	layer_set_visible(lay_walls, false);	
}

/// sand below water
var lay_sand2 = layer_create(layer_depth_below+2, "lay_sand2");
/// background water
var lay_bg1 = layer_create(layer_depth_below, "lay_water");
var bg1 = layer_background_create(lay_bg1, bg_sprite);
layer_background_htiled(bg1, 1);
layer_background_vtiled(bg1, 1);
/// background color
var lay_bg2 = layer_create(layer_depth_below+3, "lay_color");
var bg2 = layer_background_create(lay_bg2, -1);
layer_background_blend(bg2, bg_color);
/// water effect
var lay_eff = layer_create(layer_depth_below-1, "lay_effect");
water_eff = fx_create("_filter_ripples");
fx_set_parameter(water_eff, "g_RipplesPosition", [0,0]);
fx_set_parameter(water_eff, "g_RipplesSpeed", 2);
fx_set_parameter(water_eff, "g_RipplesWidth", 8);
fx_set_parameter(water_eff, "g_RipplesAmplitude", 0.78);
fx_set_parameter(water_eff, "g_RipplesRadius", 0);
layer_set_fx(lay_eff, water_eff);

/// add tilemaps
var _size = pick_tile_size(tile_size);
var _w = (room_width div _size)+2;
var _h = (room_height div _size)+2;
var map_sand = layer_tilemap_create(lay_sand, -_size, -_size, layer1_tiles, _w, _h);
var map_sand2 = layer_tilemap_create(lay_sand2, -_size, -_size/2, layer1_tiles, _w, _h);
var map_dirt = layer_tilemap_create(lay_dirt, -_size, -_size, layer2_tiles, _w, _h);
var map_grass = layer_tilemap_create(lay_grass, -_size, -_size, layer3_tiles, _w, _h);
var map_id = layer_tilemap_create(lay_id, -_size, -_size*1.25, layer_doodad_tiles, _w, _h);

/// wall map, accessible from perlin_world object
map_walls = layer_tilemap_create(lay_walls, -_size, -_size, ts_wall, _w, _h);

/// water, sand, dirt, grass -- weights
grid[0] = create_perlin_grid(_w,_h, perlin_stepsize, perlin_seed, layer_weights);
grid[1] = ds_grid_create(_w,_h);
grid[2] = ds_grid_create(_w,_h);
grid[3] = ds_grid_create(_w,_h);

/// make any adjustments to the grid here
customize_perlin_grid(grid[0]);

/// make multiple copies
ds_grid_copy(grid[1],grid[0]);
ds_grid_copy(grid[2],grid[0]);
ds_grid_copy(grid[3],grid[0]);

spawn_list = [];

/// async spawning controller
spawn_selector = {
	block_size: 128,
	container: {},
	get_location: function(_xp, _yp){
		var _xx = _xp div self.block_size;
		var _yy = _yp div self.block_size;
		var _name = $"{_xx},{_yy}";
		return _name;
	},
	insert: function(_xp, _yp, _id){
		var _name = self.get_location(_xp, _yp);
		if(variable_struct_exists(self.container, _name)){
			var _arr = self.container[$ _name];
			array_push(_arr, {x: _xp, y: _yp, id: _id});
		} else {
			self.container[$ _name]	= [{x: _xp, y: _yp, id: _id}];
		}
	},
	remove: function(_xp, _yp){
		var _name = self.get_location(_xp, _yp);
		if(variable_struct_exists(self.container, _name)){
			var _arr = self.container[$ _name];
			/// empty container
			self.container[$ _name] = [];
			return _arr;
		} else {
			return [];
		}
	}
};

/// methods for accessing grid
position_to_grid = function(xroom, yroom){
	var _size = pick_tile_size(tile_size);
	var _xx = (xroom div _size) + 1;
	var _yy = (yroom div _size) + 1;
	return {x: _xx, y: _yy};
}

grid_to_position = function(xgrid, ygrid){
	var _size = pick_tile_size(tile_size);
	return {x: (xgrid-1)*_size, y: (ygrid-1)*_size};
}

random_spawn_location = function(){
	var _ind = irandom(array_length(spawn_list)-1);
	return spawn_list[_ind];
}

for(var j = 0; j < _h; j++){
	for(var i = 0; i < _w; i++){
		/// restrict main grid to 4 values
		ds_grid_set(grid[0],i,j,min(3,ds_grid_get(grid[0],i,j)));
		/// set all first grid values
		if(ds_grid_get(grid[1],i,j) != 0){
			ds_grid_set(grid[1],i,j,1);	
		}
		/// set all second grid values
		if(ds_grid_get(grid[2],i,j) > 1){
			ds_grid_set(grid[2],i,j,1);	
		} else {
			ds_grid_set(grid[2],i,j,0);	
		}
		/// set all third grid values
		if(ds_grid_get(grid[3],i,j) > 2){
			ds_grid_set(grid[3],i,j,1);	
		} else {
			ds_grid_set(grid[3],i,j,0);	
		}
		/********* DOODADS *************/
		var dude = ds_grid_get(grid[0],i,j);
		var _r1 = doodad_range1;
		var _r2 = doodad_range2;
		var _r3 = doodad_range3;
		/// save some nice spawn locations
		if(dude > 0){
			var _pos = grid_to_position(i, j);
			if(dude > 1){
				array_push(spawn_list, _pos);
			}
			/// probability
			if(scr_chance(spawn_density)){
				spawn_selector.insert(_pos.x, _pos.y, dude);
			}
		}
		switch(dude){
			case 0:
					/// add walls
					tilemap_set(map_walls, 1, i, j);
				break;
			case 1: 
				if(chance(.05)){
					var _item = irandom_range(_r1[0],_r1[1]);
					tilemap_set(map_id, _item, i, j);
				}
				break;
			case 2:
				if(chance(.1)){
					var _item = irandom_range(_r2[0],_r2[1]);
					tilemap_set(map_id, _item, i, j);
				}
				break;
			case 3:
				if(chance(.3)){
					var _item = irandom_range(_r3[0],_r3[1]);
					tilemap_set(map_id, _item, i, j);
				}
				break;
		}
		// call spawn script
		custom_spawn_script(i, j, (i-1)*_size, (j-1)*_size, dude);
	}
}

/// set auto tile variables
lg_autotile();


/// Set tiles
lg_set_tiles("lay_sand",grid[1]);
lg_set_tiles("lay_dirt",grid[2]);
lg_set_tiles("lay_grass",grid[3]);
/// under water
lg_set_tiles("lay_sand2",grid[1]);

/*** destroy unused grids ****/
ds_grid_destroy(grid[1]);
ds_grid_destroy(grid[2]);
ds_grid_destroy(grid[3]);