// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_create_camera(){
	/*	===================================== REFERENCE =========================================
		CLASS camera:
			VARIABLES:
				target,id,x,y,w,h,xOff,yOff,shake,shakeMag,lerpRatio,borderless
			FUNCTIONS
				update()			- return NULL, updates the camera position
				reset()				- return NULL, gets the current rooms camera view size
				setShake(time,mag)	- return NULL, causes the camera to shake for time (seconds) with mag (pixel offset)
			
		===================================== NOTES ============================================
		Camera update() should be run in each room with a view that follows an object, 
		and reset() should be run at room start or display update

			
	*/
	
	/// camera follow target
	var _cam_ = {
		target: noone,
		id: 0,
		x: 0,
		y: 0,
		w: 320,
		h: 180,
		xOff: 0,
		yOff: 0,
		shake: 0,
		shakeMag: 32,
		lerpRatio: 0.1,
		borderless: false,
		saveX: 0,
		saveY: 0,
		ratio: [1,1],
		lerpDefault: 0.1,
		update: function(){
			/// move camera to player position
			if(instance_exists(target)){
				var _xto = target.x-w*0.5;
				var _yto = target.y-h*0.5;
				/// if there are borders, restrict the camera
				if(!borderless){
					_xto = clamp(_xto,0,room_width-w);
					_yto = clamp(_yto,0,room_height-h);
				}
				lerpRatio = lerp(lerpRatio, lerpDefault, 0.1);
				x = lerp(x,_xto,lerpRatio);
				y = lerp(y,_yto,lerpRatio);
			}
			/// shake the camera
			if(shake > 0){
				xOff = random_range(-0.5,0.5)*shakeMag;
				yOff = random_range(-0.5,0.5)*shakeMag;
				shake--;
			} else {
				/// return from jittering to center
				xOff = 0;
				yOff = 0;
			}
			/// set view position
			var res = 4;
			var xx = round((x+xOff)*res)/res;
			var yy = round((y+yOff)*res)/res;
			camera_set_view_pos(view_camera[id],xx,yy);
		},
		reset: function(){
			w = camera_get_view_width(view_camera[id]);
			h = camera_get_view_height(view_camera[id]);
			ratio = [display_get_gui_width()/w, display_get_gui_height()/h];
			
		},
		setShake: function(time,mag){
			shake = time*room_speed;
			shakeMag = mag;
		},
		resize: function(_w, _h, scale){
			view_set_wport(0, _w*scale);
			view_set_hport(0, _h*scale);
			surface_resize(application_surface, _w*scale, _h*scale);
			camera_set_view_size(view_camera[0], _w, _h);
			display_set_gui_size(_w*scale,_h*scale);
			window_set_size(_w*scale,_h*scale);
			reset();
		},
		mouse_gui: function(){
			var ratio1 = display_get_gui_width() / window_get_width();
			var ratio2 = display_get_gui_height() / window_get_height();
			var xx = window_mouse_get_x() * ratio1;
			var yy = window_mouse_get_y() * ratio2;
			return [xx, yy]
		},
		// transform world coordinate to gui coordinate
		world_to_gui: function(vec2){
			var xx, yy;
			xx = round((vec2.x - x) * ratio[0]);
			yy = round((vec2.y - y) * ratio[1]);
			vec2.x = xx;
			vec2.y = yy;
		},
		// transform gui coordinate to world coordinate
		gui_to_world: function(vec2){
			var xx, yy;
			xx = round((vec2.x / ratio[0]) + x);
			yy = round((vec2.y / ratio[1]) + y);
			vec2.x = xx;
			vec2.y = yy;
		},
		debug: function(){
			var _str = "-------------------------------------------"
			_str+="\ntarget: "+string(target)+"\nid: "+string(id)+"\nx: "+string(x)+"\ny: "+string(y);
			_str+="\nw: "+string(w)+"\nh: "+string(h)+"\nxOff: "+string(xOff)+"\nshake: "+string(shake);
			_str+="\nshakeMag: "+string(shakeMag)+"\n-------------------------------------------";
			return(_str);	
		},
		center_on_object: function(_obj){
			if(instance_exists(_obj)){
				var _xto = _obj.x-w*0.5;
				var _yto = _obj.y-h*0.5;
				/// if there are borders, restrict the camera
				if(!borderless){
					_xto = clamp(_xto,0,room_width-w);
					_yto = clamp(_yto,0,room_height-h);
				}
				x = _xto;
				y = _yto;
			}
		},
	}
	return(_cam_)
}

/// call when new room starts to reset camera to what is set in the room
function scr_cam_reset(cam){
	cam.reset();
}
/// call when room starts to force camera to this size
function scr_cam_set_size(cam, w, h, scale){
	cam.resize(w, h, scale);
}
/// make the camera shake, in seconds, with pixel offset
function scr_cam_shake(cam, time, mag){
	cam.setShake(time, mag);
}
/// call this in step event to keep camera working
function scr_cam_update(cam){
	cam.update();	
}
/// call this to change what the camera is following
function scr_cam_set_target(cam, targetObject){
	cam.target = targetObject;
}

/// deactivating instances outside of view to lower object overhead
function scr_disable_outside_view(cam, targetObject){
	var padding = 16;
	instance_deactivate_object(targetObject);
	instance_activate_region(cam.x-padding,cam.y-padding,cam.w+padding*2,cam.h+padding*2,1);
}

/// switch between coordinate systems for GUI / World
function scr_transform_coordinates(cam, vec2, to_gui){
	if(to_gui){
		cam.world_to_gui(vec2);	
	} else {
		cam.gui_to_world(vec2);	
	}
}