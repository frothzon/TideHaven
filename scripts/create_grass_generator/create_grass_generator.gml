// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_grass_generator(sprite_grass = spr_grass, depth_sort = true){
	
	// Vertex buffer
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, VERTEX_FORMAT);

	var grass_builder = {
		sprite: sprite_grass,
		frames : sprite_get_number(sprite_grass),
		texture : sprite_get_texture(sprite_grass, 0),

		width : 16,
		height : 16,
		plant_width : 10,
		plant_height : 10,

		// Grass properties
		grassCount : 3,

		color : c_white,
		alpha : 1,
		
		buff: vbuff,
		popout: depth_sort,

		add_patch: function(x1, y1){
			repeat (self.grassCount) {
			    // Next 4 code sections go here
			    // 1: Grass coordinates
				var _x1 = irandom_range(x1 + self.width * 0.5 - self.plant_width * 0.25, x1+self.width - self.plant_width * 0.25);
				var _y1 = irandom_range(y1 - self.height * 0.25 + self.plant_height * 0.25, y1+self.height - self.plant_height * 0.5);
				var _x2 = _x1 + self.plant_width;
				var _y2 = _y1 + self.plant_height;

				var _depth = popout ? -(_y2 / 8) : 0;
			    // 2: Texture coordinates
				var _frame = irandom(self.frames - 1);
				var _uvs = sprite_get_uvs(self.sprite, _frame);

				var _uv_x1 = _uvs[0];
				var _uv_y1 = _uvs[1];
				var _uv_x2 = _uvs[2];
				var _uv_y2 = _uvs[3];
			    // 3: Triangle 1
				add_vertex(self.buff, _x1, _y1, _depth, _uv_x1, _uv_y1, self.color, self.alpha, 1);

				add_vertex(self.buff, _x2, _y1, _depth, _uv_x2, _uv_y1, self.color, self.alpha, 1);

				add_vertex(self.buff, _x1, _y2, _depth, _uv_x1, _uv_y2, self.color, self.alpha, 0);
				
			    // 4: Triangle 2
				add_vertex(self.buff, _x2, _y1, _depth, _uv_x2, _uv_y1, self.color, self.alpha, 1);

				add_vertex(self.buff, _x1, _y2, _depth, _uv_x1, _uv_y2, self.color, self.alpha, 0);

				add_vertex(self.buff, _x2, _y2, _depth, _uv_x2, _uv_y2, self.color, self.alpha, 0);
			};
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

function add_vertex(buff, x1, y1, z1, uvx, uvy, col, alpha, weight){
	vertex_position_3d(buff, x1, y1, z1);
	vertex_texcoord(buff, uvx, uvy);
	vertex_color(buff, col, alpha);	
	vertex_float1(buff, weight);
}