/// @description setup player

key_vector = new scr_vec2_class();
heldItem = instance_create_depth(x,y,-100,obj_pickaxe);
object_spawner = [];

/// local spawning points
spawn_points = [{x: 0, y: 0}];
spawn_time_start = current_time;

/// setup stats
scr_setup_statvars(25, 1, 1.0, 100);

/// setup leveling up
/*
level = 1;
level_points = 0;
exp_amount = scr_set_statvar(0,"EXP", 100);
*/

var _layer = layer_get_id("Walls");
layer_set_visible(_layer, false);
_layer = layer_get_id("Climb");
layer_set_visible(_layer, false);

/// keep track of states using switch case statements
scr_setup_state_machine();

/// set self to cam target
scr_cam_set_target(CAMERA, id);

enum STATE{
	def,
	hurt,
	block
};

animator = [
	/// right
	char_idle_right_anim,
	/// up
	char_idle_up_anim,
	/// left
	char_idle_left_anim,
	/// down
	char_idle_down_anim
];

sprite_selection = 3;
flip_tool = false;
tool_offset = 1;
tool_depth = 1;
is_climbing = false;
held_shield = false;
full_screen = 0;
regen_timer = 0;
fishing_cooldown = 0;

/// deactivating objects not in view
alarm[0] = 1;
alarm[1] = 1;
alarm[2] = 1;

/// set cam
scr_cam_set_size(CAMERA, CAM_W, CAM_H, CAM_SCALE);

/// PLAYER_BAG controlling object
instance_create_depth(0,0,0,obj_player_bag);

/// load sprites
//scr_gen_mon_sprites();
textbox = new tb_textbox_class();

/// create stat nodes
setup_skills();

/// setup minimap
map = new Minimap();

/// static build = function(layer_names, map_w, map_h, px, py)