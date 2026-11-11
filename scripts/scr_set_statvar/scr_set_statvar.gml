// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_set_statvar(_value, _name = "", _max=-1){
	var statvar = {
		value: _value,
		max_value: _max == -1 ? _value : _max,
		start_value: _value,
		name: _name,
		draw_value: _value,
		ratio: function(){
			draw_value = lerp(draw_value, value, 0.25);
			return(draw_value / max_value);
		},
		set: function(val, relative){
			max_value = val + (max_value * relative);
			if(val > max_value){
				val = max_value;
			}
			value = max_value;
			scr_debug("HP Set...");
		},
		change: function(val, relative){
			set(val, relative);
			start_value = val + (start_value * relative);
		},
		add: function(val){
			value = clamp(value+val, -1, max_value);
		},
		reset: function(){
			self.set(start_value, 0);
		},
		toString: function(){
			return(scr_concat(name,": ",value,"/",max_value));
		},
		export: function(){
			var _data = {
				value,
				max_value,
				start_value
			}
			return _data;
		},
		import: function(_data){
			if(is_struct(_data)){
				value = _data.value;
				max_value = _data.max_value;
				start_value = _data.start_value;
			}
		}
	}
	return(statvar);
}

function scr_change_statvar(stat, val, relative){
	stat.set(val, relative);
}

function scr_reset_statvar(stat){
	stat.reset();
}