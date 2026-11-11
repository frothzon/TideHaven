// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_world_chunk_size(){
	/// this will remove the spawn chunk from the spawn selector to prevent duplicate spawns
	/// sends chunks of spawn locations from a grid patch -- for async spawning
	return perlin_world.spawn_selector.block_size;
}