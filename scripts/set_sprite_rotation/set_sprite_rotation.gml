// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_sprite_rotation(sprite_arr, angle){
	while(angle < 0){
		angle += 360;	
	}
	if(sprite_arr == undefined){
		return 0;	
	}
	var data = json_parse(json_stringify(sprite_arr, 0));
	if(!is_array(data)){
		data = array_create(4, data);	
	}
	var ind = round(angle / 90) % 4;
	sprite_index = data[ind];
}