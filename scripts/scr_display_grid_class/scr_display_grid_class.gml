// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_display_grid_class(_x,_y,_width,_height,_hcount,_vcount) constructor{
	//=================== Variables ========================//
	x = _x; //............................. x position of grid
	y = _y; //............................. y position of grid
	width = _width; //..................... width of cell in grid
	height = _height; //................... height of cell in grid
	hcount = _hcount; //................... cell horizontal count
	vcount = _vcount; //................... cell virtical count
	xmove = _x; //......................... move to the new x position
	ymove = _y; //......................... move to the new y position
	moveRatio = 0.2; //.................... lerp ratio to move
	//=================== Functions ========================//
	/// @desc pointToIndex(px, py) -> get cell index of point X and point Y, -1 if not in cell
	/// @param px
	/// @param py
	static pointToIndex = function(px, py){
		var _index = -1;
		if(point_in_rectangle(px,py,x,y,x+width*hcount,y+height*vcount)){
				
			/// convert input position to cell position in grid
			var xoffset = (px - x) div width;
			var yoffset = (py - y) div height;

			/// [4] check if the x and y values are within the boundares
			if(xoffset >= 0 && xoffset < hcount && yoffset >= 0 && yoffset < vcount){
				/// change index value
				_index = xoffset + yoffset * hcount;
			}
		}
		return(_index);	
	};
	/// @desc gridRect() -> get rectangle for complete grid dimensions x1, y1, x2, y2
	static gridRect = function(){
		var _rect = new scr_rect_class(x, y, hcount * width, vcount * height);
		return(_rect);
	};
	/// @desc size() -> get total cell count in grid
	static size = function(){
		return(hcount*vcount);
	};
	/// @desc cellRect(index) -> get coordinates for x,y,w,h of cell at index provided
	/// @param index
	static cellRect = function(index){
		if(index >= 0 && index < size()){
			var cellX = index mod hcount; /// gets the horizontal component of id
			var cellY = index div hcount; /// gets the virtical component of id
			var px = x + cellX * width;
			var py = y + cellY * height;
				
			var _box_ = new scr_rect_class(px, py, width, height);

			return(_box_);
		} else {
			show_error("Index out of range",false);	
			return(-1);
		}
	};
	/// @desc forEach(fcn_name) -> loop through each cell in grid
	/// @param function -> arguments: (index, cellRect)
	static forEach = function(fcn_name){
		var len = size();
		for(var i = 0; i < len; i++){
			/// function(index, box)
			fcn_name(i, cellRect(i));
		}
	};
	static update = function(){
		x = lerp(x, xmove, moveRatio);
		y = lerp(y, ymove, moveRatio);
	};
	static bounds = function(){
		return {x,y,w: width*hcount, h: height*vcount}; 	
	}
}

// rectangle
function scr_rect_class(x1,y1,w1,h1) constructor{
	x = x1;
	y = y1;
	w = w1;
	h = h1;
	static x2 = function(){
		return(x+w);
	};
	static y2 = function(){
		return(y+h);
	}
}