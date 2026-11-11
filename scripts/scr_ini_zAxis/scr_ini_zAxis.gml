// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ini_zAxis(){
	/*	===================================== REFERENCE =========================================
		CLASS _zaxis_
			VARIABLES:
				z,z_gravity,z_speed,z_freeze,z_ground,z_float
			FUNCTIONS:
				update()				- return NULL, moves the unit on the z axis using gravity
				onGround()				- returns 0|1, checks if the unit is on the ground
				jump(spd)				- return NULL, if the player is on the ground, jump up at the specified speed
				
		create_zAxis()					- return _zaxis_
				
			
		===================================== NOTES ============================================
		Each game unit in the world should have a z_axis. This allows for the illusion of a 3rd dimension

	*/
	
	zAxis = {
		/// create zaxis variables
		z : 0,
		z_gravity : 0.5,
		z_speed : 0,
		z_freeze : false,
		z_ground : 0,
		z_float : false,
		/// create zaxis functions
	
		/// set motion
		update : function(){
			if(!z_freeze){
			    z_speed -= z_gravity;
			    z += z_speed;
    
			    if(z < z_ground){
			        z = z_ground;
			        z_speed = 0;
			    }
    
			    if(z_float){
			    var _sink = -sprite_height*0.5 + wave(-4,4,1.5,0);
			        if(z < _sink && z_speed < 0){
			            z_speed = 0;
			            z = _sink;
			        }
			    }
			}	
		},
		onGround : function(){
			return(z <= z_ground);
		},
		jump : function(_spd){
			if(onGround){
				z_speed = _spd;
			}
		},
	}
}