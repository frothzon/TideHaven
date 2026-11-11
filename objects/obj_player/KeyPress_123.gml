/// @description toggle full screen

full_screen = !full_screen;
window_set_fullscreen(full_screen);

if(full_screen){
	//CAM_SCALE = display_get_width() / CAM_W;
	CAM_SCALE = display_get_gui_width() / CAM_W;
} else {
	CAM_SCALE = display_get_gui_width() / CAM_W;
}
var ratio = display_get_width() / display_get_height();
CAM_W = ratio * CAM_H;
scr_cam_set_size(CAMERA, CAM_W, CAM_H, CAM_SCALE);
CAMERA.center_on_object(id);
CAMERA.lerpRatio = 1;
scr_init_bag_gui();


