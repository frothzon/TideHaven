// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_tile_generator(sprite_grass = spr_grass){
	
	// Vertex buffer
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, VERTEX_FORMAT);

	var grass_builder = {
		sprite: sprite_grass,
		frames : sprite_get_number(sprite_grass),
		texture : sprite_get_texture(sprite_grass, 0),

		width : 16,
		height : 16,

		color : c_white,
		alpha : 1,
		
		buff: vbuff,

		add_tile: function(x1, y1, frame_index, z1=0){
			// Next 4 code sections go here
			// 1: Grass coordinates
			var _x1 = x1;
			var _y1 = y1;
			var _x2 = x1 + self.width;
			var _y2 = y1 + self.height;

			// 2: Texture coordinates
			var _uvs = sprite_get_uvs(self.sprite, frame_index);

			var _uv_x1 = _uvs[0];
			var _uv_y1 = _uvs[1];
			var _uv_x2 = _uvs[2];
			var _uv_y2 = _uvs[3];
			// 3: Triangle 1
			add_vertex(self.buff, _x1, _y1, z1, _uv_x1, _uv_y1, self.color, self.alpha, 0);

			add_vertex(self.buff, _x2, _y1, z1, _uv_x2, _uv_y1, self.color, self.alpha, 0);

			add_vertex(self.buff, _x1, _y2, z1, _uv_x1, _uv_y2, self.color, self.alpha, 0);
				
			// 4: Triangle 2
			add_vertex(self.buff, _x2, _y1, z1, _uv_x2, _uv_y1, self.color, self.alpha, 0);

			add_vertex(self.buff, _x1, _y2, z1, _uv_x1, _uv_y2, self.color, self.alpha, 0);

			add_vertex(self.buff, _x2, _y2, z1, _uv_x2, _uv_y2, self.color, self.alpha, 0);
		},
		end_builder: function(){
			vertex_end(self.buff);
			vertex_freeze(self.buff);
		},
		render: function(){
			vertex_submit(self.buff, pr_trianglelist, self.texture);
		},
		cleanup: function(){
			vertex_delete_buffer(self.buff);
		}
	};
	
	return grass_builder;
}