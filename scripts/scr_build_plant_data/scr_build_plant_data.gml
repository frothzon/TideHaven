// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// create plant container
function scr_build_plant_data(_name, _time_max=0, _sprite=-1, _drop_item=-1, _range=[1,1]){
	var _time = scr_get_timevalue();
	var _data = {
		grow_time : _time_max,
		time_planted : _time,
		sprite : _sprite,
		index : 0,
		name : _name,
		drop : _drop_item,
		range : _range,
		state : 0,
		ratio : 0
	}
	return(_data);
}

// get the current day-time in seconds
function scr_get_timevalue(){
	var _time = current_day * 86400;
	_time += current_hour * 3600;
	_time += current_minute * 60;
	_time += current_second;
	return(_time);
}

function copy_new_plant(plant_obj){
	var obj = json_parse(json_stringify(plant_obj));
	with(obj){
		state = 0;
		ratio = 0;
		index = 0;
		time_planted = scr_get_timevalue();
		drop = plant_obj.drop;
	}
	return(obj);
}

function get_plant_ratio(plant_obj){
	var rr = (scr_get_timevalue()-plant_obj.time_planted)/plant_obj.grow_time;
	return(clamp(rr, 0, 1));
}