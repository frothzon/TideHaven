/// @function lg_bitmask(north, east, south, west);
/// @description return the value calculated from the bitmask function
/// @param {bool} north
/// @param {bool} east
/// @param {bool} south
/// @param {bool} west
function lg_bitmask(argument0, argument1, argument2, argument3) {

	var _tile_index = NORTH*argument0 + EAST*argument1 + SOUTH*argument2 + WEST*argument3 + 1;
	return(_tile_index);



}
