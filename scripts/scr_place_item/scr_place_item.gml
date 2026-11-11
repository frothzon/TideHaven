// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_place_item(xto, yto, item, amount){
	var _obj = instance_create_depth(xto, yto-8, 0, obj_collectible);
	_obj.item = item;
	_obj.amount = amount;
	return(_obj);
}