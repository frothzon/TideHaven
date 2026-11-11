// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// @desc create_perlin_grid(_w, _h, _steps,  _seed=-1, _weights=[1,2,3,4])
/// @param width
/// @param height
/// @param steps
/// @param seed
/// @param weights
function create_perlin_grid(_w, _h, _steps,  _seed=-1, _weights=[1,2,3,4]){
	
	if(_seed >= 0){
		random_set_seed(_seed);
	} else {
		randomize();	
	}
	
	/// for calculating and selecting from weighted average
	var wgt = {
		values: _weights,
		calc: array_reduce(_weights, function(_previous, _current, _index){return _previous + _current}),
		get: function(ratio){
			var val = ratio * self.calc;
			var len = array_length(self.values);
			for(var i = 0; i < len; i++){
				val -= self.values[i];
				if(val <= 0){
					return i;
				}
			}
			return len-1;
		}
	}
	
	if(debug_mode){
		show_debug_message(json_stringify(wgt, 1));
	}
	
	/// object to getnerate perlin noise
	var perlin = {
		gradients: ds_map_create(),
		memory: ds_map_create(),
		to_key: function(dx, dy){
			return("["+string(dx)+","+string(dy)+"]");
		},
	    rand_vect: function(){
	        var theta = random(2) * pi;
	        return ({x: cos(theta), y: sin(theta)});
	    },
	    dot_prod_grid: function(x, y, vx, vy){
	        var g_vect;
	        var d_vect = {x: x - vx, y: y - vy};
	        if (gradients[? to_key(vx,vy)]){
	            g_vect = gradients[? to_key(vx,vy)];
	        } else {
	            g_vect = rand_vect();
	            gradients[? to_key(vx,vy)] = g_vect;
	        }
	        return d_vect.x * g_vect.x + d_vect.y * g_vect.y;
	    },
	    smootherstep: function(x){
			var out = 6*power(x,5)-15*power(x,4)+10*power(x,3);
	        return out;
	    },
	    interp: function(x, a, b){
	        return a + smootherstep(x) * (b-a);
	    },
	    seed: function(){
	        ds_map_clear(gradients);
	        ds_map_clear(memory);
	    },
	    get: function(x, y) {
	        if (ds_map_exists(memory, to_key(x,y)))
	            return memory[? to_key(vx,vy)];
	        var xf = floor(x);
	        var yf = floor(y);
	        //interpolate
	        var tl = dot_prod_grid(x, y, xf,   yf);
	        var tr = dot_prod_grid(x, y, xf+1, yf);
	        var bl = dot_prod_grid(x, y, xf,   yf+1);
	        var br = dot_prod_grid(x, y, xf+1, yf+1);
	        var xt = interp(x-xf, tl, tr);
	        var xb = interp(x-xf, bl, br);
	        var v = interp(y-yf, xt, xb);
	        memory[? to_key(x,y)] = v;
	        return (v+0.64)/1.28;
	    },
		cleanup: function(){
			ds_map_destroy(memory);
			ds_map_destroy(gradients);
		}
	}
	
	var _grid = ds_grid_create(_w,_h);
	//test = [100,-100,"??"];
	for(var i = 0; i < _w; i++){
		for(var j = 0; j < _h; j++){
			var _output = perlin.get(i/_steps, j/_steps);
			_grid[# i, j] = wgt.get(_output);//floor(_output*_values);
		}
	}
	//show_debug_message(test);
	
	perlin.cleanup();
	delete perlin;
	delete wgt;
	
	return(_grid);

}