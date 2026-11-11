/// @description  setup_animate(sprite, life);
/// @param sprite
/// @param  life
function setup_animate(argument0, argument1) {


	var _sp, _life, _id;
	_id = part_type_create();

	part_type_sprite(_id,argument0,true,true,false);
	part_type_life(_id,argument1,argument1);

	partArray_add(_id);
	return(_id);



}
