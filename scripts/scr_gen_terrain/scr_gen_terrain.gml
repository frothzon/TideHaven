// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_gen_terrain(bit_data = 0){
	
	scr_print("Room shape: ", bit_data);
	
	var ww = INITIAL_LAND_SIZE >> 4;
	var hh = INITIAL_LAND_SIZE >> 4;

	ground_grid = ds_grid_create(ww, hh);
	ds_grid_set_region(ground_grid,0,0,ww-1,hh-1,1);
	position_list = [];
	
	
	/// right side
	if(bit_data & 1 == 0){
		ds_grid_set_region(ground_grid, ww-2, 0, ww-1, hh-1, 0);
		repeat(10){
			xx = ww-2;
			yy = irandom(hh-1);
			ds_grid_set_disk(ground_grid, xx, yy, irandom_range(1,3), 0);
		}
	}
	/// left side
	if(bit_data & 4 == 0){
		ds_grid_set_region(ground_grid, 0, 0, 1, hh-1, 0);
		repeat(10){
			xx = 1;
			yy = irandom(hh-1);
			ds_grid_set_disk(ground_grid, xx, yy, irandom_range(1,3), 0);
		}
	}
	/// top side
	if(bit_data & 2 == 0){
		ds_grid_set_region(ground_grid, 0, 0, ww-1, 1, 0);
		repeat(10){
			xx = irandom(ww-1);
			yy = 1;
			ds_grid_set_disk(ground_grid, xx, yy, irandom_range(1,3), 0);
		}
	}
	/// bottom side
	if(bit_data & 8 == 0){
		ds_grid_set_region(ground_grid, 0, hh-2, ww-1, hh-1, 0);
		repeat(10){
			xx = irandom(ww-1);
			yy = hh-2;
			ds_grid_set_disk(ground_grid, xx, yy, irandom_range(1,3), 0);
		}
	}

	/// place ground tiles
	var lay1 = layer_get_id("GroundUp");
	var map_id1 = layer_tilemap_get_id(lay1);
	var lay2 = layer_get_id("GroundDown");
	var map_id2 = layer_tilemap_get_id(lay2);
	var lay3 = layer_get_id("GroundBottom");
	var map_id3 = layer_tilemap_get_id(lay3);
	var lay4 = layer_get_id("Doodad");
	var map_id4 = layer_tilemap_get_id(lay4);
	
	/// middle of world -- shifted back by middle of land mass
	var start_x = ((room_width >> 1) - (INITIAL_LAND_SIZE >> 1)) >> 4;
	var start_y = ((room_height >> 1) - (INITIAL_LAND_SIZE >> 1)) >> 4;

	for(var i = 0; i < ww; i++){
		for(var j = 0; j < hh; j++){
			var xm = start_x + i;
			var ym = start_y + j;
			
			tilemap_set(map_id1, ground_grid[# i, j], xm, ym);
			tilemap_set(map_id2, ground_grid[# i, j]*2, xm, ym);
			tilemap_set(map_id3, ground_grid[# i, j]*2, xm, ym);
			if(scr_chance(0.25) && ground_grid[# i, j] != 0){
				var ind = scr_random_weighted([0,1,1,20,2,20,20,2,2,2,1,1,2,2,1,1]);
				tilemap_set(map_id4, ind, xm, ym);
			}
			if(ground_grid[# i, j] == 0){
				//var _obj = instance_create_depth(xm*16,ym*16,0,obj_wall);
				//_obj.visible = false;
			} else {
				array_push(position_list, [xm*16+8,ym*16+16]);	
			}
		}
	}

}