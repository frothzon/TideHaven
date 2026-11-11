// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_create_dungeon(_size = 16, _maxRooms = random_range(10,20)){
	var _dungeonData = {
		room_count: 0,
		region_array: [],
		room_edge_array: [],
		grid: ds_grid_create(_size,_size),
		get_value: function(ind){
			var pnt = region_array[ind];
			return(grid[# pnt[0], pnt[1]]);
		},
		get_size: function(){
			return(array_length(region_array));	
		},
		search: function(pos_array){
			var len = array_length(region_array);
			var index = -1;
			for(var i = 0; i < len; i++){
				if(array_equals(pos_array, region_array[i])){
					return(i);	
				}
			}
		}
	};
	
	_dungeonData.grid = ds_grid_create(_size,_size);
	/// set forbidden cells
	ds_grid_clear(_dungeonData.grid,0);
	/// set empty cells
	ds_grid_set_region(_dungeonData.grid,1,1,_size-2,_size-2,16);
	
	/// set next cell to be modified
	_dungeonData.room_count = 1;
	var _xstart = _size>>1;
	var _ystart = _size>>1;
	_dungeonData.grid[# _xstart, _ystart] = scr_random_bitShift([1,1,1,1]);
	
	/// function to fill region array
	var addPointsToArray = function(grid_x,grid_y,_dungeonData){
		var _val = _dungeonData.grid[# grid_x, grid_y];
		show_debug_message("test");
		show_debug_message(_val);
		if((_val & 1) > 0){
			show_debug_message("&1");
			//var _ind = array_length(_dungeonData.region_arrray);
			var _data = [grid_x+1, grid_y];
			if(_dungeonData.grid[# _data[0], _data[1]] == 16){
				_dungeonData.grid[# _data[0], _data[1]] = 0;
				array_push(_dungeonData.region_array, _data);
				//_dungeonData.region_arrray[_ind] = _data;
			}
		}
		if((_val & 2) > 0){
			show_debug_message("&2");
			//var _ind = array_length(_dungeonData.region_arrray);
			var _data = [grid_x, grid_y-1];
			if(_dungeonData.grid[# _data[0], _data[1]] == 16){
				_dungeonData.grid[# _data[0], _data[1]] = 0;
				array_push(_dungeonData.region_array, _data);
				//_dungeonData.region_arrray[_ind] = _data;
			}
		}
		if((_val & 4) > 0){
			show_debug_message("&4");
			//var _ind = array_length(_dungeonData.region_arrray);
			var _data = [grid_x-1, grid_y];
			if(_dungeonData.grid[# _data[0], _data[1]] == 16){
				_dungeonData.grid[# _data[0], _data[1]] = 0;
				array_push(_dungeonData.region_array, _data);
				//_dungeonData.region_arrray[_ind] = _data;
			}
		}
		if((_val & 8) > 0){
			show_debug_message("&8");
			//var _ind = array_length(_dungeonData.region_arrray);
			var _data = [grid_x, grid_y+1];
			if(_dungeonData.grid[# _data[0], _data[1]] == 16){
				_dungeonData.grid[# _data[0], _data[1]] = 0;
				//_dungeonData.region_arrray[_ind] = _data;
				array_push(_dungeonData.region_array, _data);
			}
		}
	}
	
	var getAdjacentArray = function(_posArray, _grid){
		var _indexCheck;
		_indexCheck[0] = _grid[# _posArray[0]+1, _posArray[1]] == 16;
		_indexCheck[1] = _grid[# _posArray[0], _posArray[1]-1] == 16;
		_indexCheck[2] = _grid[# _posArray[0]-1, _posArray[1]] == 16;
		_indexCheck[3] = _grid[# _posArray[0], _posArray[1]+1] == 16;
		return(_indexCheck);
	}
	
	var getNeighborValue = function(_posArray, _grid){
		var value = 0;
		value += ((_grid[# _posArray[0]+1, _posArray[1]] & 4) > 0)*1;
		value += ((_grid[# _posArray[0]-1, _posArray[1]] & 1) > 0)*4;
		value += ((_grid[# _posArray[0], _posArray[1]+1] & 2) > 0)*8;
		value += ((_grid[# _posArray[0], _posArray[1]-1] & 8) > 0)*2;
		return(value);
	}
	
	
	/// set next positions
	_dungeonData.region_array[0] = [_xstart,_ystart];
	addPointsToArray(_xstart,_ystart,_dungeonData);
	
	show_debug_message(_dungeonData.region_array);
	
	for(var b = 1; b < array_length(_dungeonData.region_array); b++){
		var _posCheck = _dungeonData.region_array[b];
		/// add to grid
		if(_dungeonData.room_count < _maxRooms){
			if(_dungeonData.grid[# _posCheck[0], _posCheck[1]] != 0){
				continue;
			}
			/// check the cells sitting against the current room
			var _indexCheck = getAdjacentArray(_posCheck,_dungeonData.grid);
			var _newRoom = 0;
			if(_indexCheck[0] > 0 || _indexCheck[1] > 0 || _indexCheck[2] > 0 || _indexCheck[3] > 0){
				/// assign random doors to new room
				_newRoom = scr_random_bitShift(_indexCheck);
				/// assign cell that value
				///setNeighborValue(_newRoom,_posCheck,_grid);
				_dungeonData.grid[# _posCheck[0], _posCheck[1]] = _newRoom;
				addPointsToArray(_posCheck[0], _posCheck[1], _dungeonData);
				/// chance to do it again
				if(random(1) < 2){
					_indexCheck = getAdjacentArray(_posCheck,_dungeonData.grid);
					if(_indexCheck[0] > 0 || _indexCheck[1] > 0 || _indexCheck[2] > 0 || _indexCheck[3] > 0){
						_newRoom += scr_random_bitShift(_indexCheck);
						//setNeighborValue(_newRoom,_posCheck,_grid);
						_dungeonData.grid[# _posCheck[0], _posCheck[1]] = _newRoom;
						addPointsToArray(_posCheck[0], _posCheck[1], _dungeonData);
					}
				}
			}
			_newRoom += getNeighborValue(_posCheck,_dungeonData.grid);
			_dungeonData.grid[# _posCheck[0], _posCheck[1]] = _newRoom;
			show_debug_message(_dungeonData.region_array);
			_dungeonData.room_count++;
			
		} else {
			var _newRoom = getNeighborValue(_posCheck,_dungeonData.grid);
			_dungeonData.grid[# _posCheck[0], _posCheck[1]] = _newRoom;
			
		}
	};
	_dungeonData.room_edge_array = [];
	var _len = array_length(_dungeonData.region_array);
	for(var i = 0; i < _len; i++){
		var _pos = _dungeonData.region_array[i];
		var _val = _dungeonData.grid[# _pos[0], _pos[1]];
		var _isEdge = ((_val&1 > 0) + (_val&2 > 0) + (_val&4 > 0) + (_val&8 > 0)) == 1;
		if(_isEdge){
			array_push(_dungeonData.room_edge_array, _pos);
		}
	}
	return(_dungeonData);
}