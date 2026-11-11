/// @description respawn

if(current_time / 1000 > respawn_time){
	if(spawn >= 0){
		instance_create_depth(x,y,0,spawn);	
	}

	instance_destroy();
}

