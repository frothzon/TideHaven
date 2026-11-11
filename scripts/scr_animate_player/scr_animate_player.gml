// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_animate_player(vec){
	if(vec.length() > 0){
		var dir = vec.angle();
		sprite_selection = round( dir / 90) % 4;
	}
	
	/// tool position and scaling
	tool_depth = 1;
	tool_offset = -3;
	flip_tool = false;
	switch(sprite_selection){
		case 0: tool_offset = 1;
				tool_depth = -1;
		break;
		case 1: flip_tool = true;
		break;
		case 2: tool_offset = 1;
				flip_tool = true;
		break;
		case 3: tool_depth = -1;
		break;
	}
	
	/// climbing
	if(is_climbing){
		scr_climb_animations();	
	}
		
	sprite_index = animator[sprite_selection];
}