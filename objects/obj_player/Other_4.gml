/// @description reset camera

/// calculate size
var ratio = display_get_width() / display_get_height();
CAM_W = ratio * CAM_H;
scr_cam_set_size(CAMERA, CAM_W, CAM_H, CAM_SCALE);
CAMERA.center_on_object(id);
CAMERA.lerpRatio = 1;
scr_init_bag_gui();
spawn_time_start = current_time;
