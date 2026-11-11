// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Minimap() constructor{
	map = -1;
	width = 0;
	height = 0;
	surf = -1;
	alpha = 0.8;
	alpha_max = 0.9;
	show = false;
	static build = function(layer_names, colors, map_w, map_h, px, py){
		if(self.map != -1){
			ds_grid_destroy(self.map);
		}
		
		self.map = ds_grid_create(map_w, map_h);
		self.width = map_w;
		self.height = map_h;
		
		ds_grid_clear(self.map, 0);
		
		var qty = array_length(layer_names);
		for(var s = 0; s < qty; s++){
			var obj = layer_names[s];
			var col = colors[s];
			
			/// if layer
			if(is_string(obj)){
				var lay = layer_get_id(obj);
				var tmap = layer_tilemap_get_id(lay);
				for(var j = 0; j < map_h; j++){
					for(var i = 0; i < map_w; i++){
						var value = tilemap_get_at_pixel(tmap, i * px, j * py);
						if(value > 0){
							ds_grid_set(self.map, i, j, col);
						}
					}
				}
			} else {
				var x1 = obj.bbox_left div px;
				var y1 = obj.bbox_top div py;
				var x2 = obj.bbox_right div px;
				var y2 = obj.bbox_bottom div py;
				
				ds_grid_set_region(self.map, x1, y1, x2, y2, col);
			}
		}
	};
	
	static draw = function(sprite_bg, sprite_cell, xto, yto, width, height){
		if(!self.show){
			self.alpha = lerp(self.alpha, 0, 0.25);
		} else {
			self.alpha = lerp(self.alpha, self.alpha_max, 0.25);
		}
		if(self.alpha <= 0){
			return;	
		}
		if(!surface_exists(self.surf)){
			var xcell = 8;
			var ycell = 8;
			var max_w = self.height * xcell;
			var max_h = self.height * ycell;
			self.surf = surface_create(max_w + 12, max_h + 12);
			surface_set_target(self.surf);
			draw_clear_alpha(c_black, 0);
			draw_sprite_stretched(sprite_bg, 0, 0, 0, max_w + 12, max_h + 12);
			if(self.map != -1){
				for (var j = 0; j < self.height; ++j) {
				    for (var i = 0; i < self.width; ++i) {
					    // code here
						if(self.map[# i, j] > 0){
							var _x = i * xcell + 4;
							var _y = j * ycell + 4;
							draw_sprite_stretched_ext(sprite_cell, 0, _x, _y, xcell, ycell,self.map[# i, j],1);
						}
					}
				}
			}
			surface_reset_target();
		} else {
			draw_surface_stretched_ext(self.surf, xto, yto, width, height,c_white,self.alpha);	
			draw_set_alpha(self.alpha)
			with(obj_player){
				var xx = x / room_width * width + xto;
				var yy = y / room_height * height + yto;
				draw_set_color(c_lime);
				draw_circle(xx, yy, 4, false);
			}
			scr_draw_reset();
		}
	};
}