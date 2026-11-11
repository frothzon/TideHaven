// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_gen_seed_array(size = 30){
	var arr = [];
	for(var i = 0; i < size; i++){
		randomize();
		array_push(arr, random_get_seed());
	}
	return(arr);
}