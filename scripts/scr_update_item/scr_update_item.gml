// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_update_item(){
	if(scr_check_instance(heldItem)){
		var scale = flip_tool ? -1 : 1;
		heldItem.x = x + scale * tool_offset;
		heldItem.y = y + 2;
		heldItem.depth = depth + tool_depth;
		heldItem.mirror = scale;
		heldItem.visible = !held_shield;
	}
}