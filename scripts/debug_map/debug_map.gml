/// @desc debug_map(id,x,y);
/// @param id
/// @param x
/// @param y
function debug_map(argument0, argument1, argument2) {

	for(var j = 0; j < ds_grid_height(argument0); j++){
		for(var i = 0; i < ds_grid_width(argument0); i++){
			var _rect;
			_rect = [argument1+i*4,argument2+j*4,argument1+(i+1)*4,argument2+(j+1)*4];
			var _cc = make_colour_rgb(0,ds_grid_get(argument0,i,j),0);
			draw_set_colour(_cc);
			draw_rectangle(_rect[0],_rect[1],_rect[2],_rect[3],false);
			draw_set_colour(c_white);
		}
	}



}
