// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/*
	store all data in as few global variables as possible by aggregating data into two groups
	
	config - user configurable data (you can load and save)
	controller - static data that gets defined at game start
*/
function config(){
	/// pre-compie things in here
	gml_pragma("global","config()");
    
    // particles
    setup_particle_engine();
	
	/// store all global vars / game data in config so it is easy to load and save
	/// (only data, no functions stored)
	global.CONFIG = {
		left: ord("A"),		/// button id
		right: ord("D"),	/// button id
		up: ord("W"),		/// button id
		down: ord("S"),		/// button id
		destroy: ord("X"),	/// button id
		equip: ord("E"),	/// button id
		force: vk_shift,
		music_volume: 0.5,
		sound_volume: 0.5,
		view_width: 200,
		view_height: 150,
		view_scale: 4,
		gui_block_size: 48,
		gui_item_size: 32,
		item_id: 1,
		bag: 0,
		gear: 0,
		level: 1,
		level_points: 0,
		exp_amount: scr_set_statvar(0,"EXP", 25),
		exp_multiplyer: 1,
		world_seeds: scr_gen_seed_array(),
		world_data: scr_create_dungeon(),
		world_index: 0,
		world_objects: [],
		creature_list: scr_gen_seed_array(),
		skill_data: array_create(26, -1),
		player_stats: {life:-1,damage:-1,spd:-1},
		player_skills: -1
	};
	
	/// controller (pointers that must be initialized at game start and can't be loaded)
	global.CONTROLLER = {
		
		/// systems
		SEemitter: audio_emitter_create(),
		MUSemitter: audio_emitter_create(),
		BattleMUS: audio_emitter_create(),
		camera: scr_create_camera(),
		game_paused: false,
		savable_objects: [
			obj_builder_floor,
			obj_breakable_parent
		],
		world_ready: array_create(30, 0),
		
		/// PLAYER_BAG variables
		slot_count: 30,
		tab_count: 7,
		slot_hover: -1,
		slot_selection: -1,
		paused: false,
		menu_view: 0,
		item_slots: -1,
		tab_slots: -1,
		gear_select: 0,
		gear_slots: 0,
		itm_desc_box: -1,
		pause_pos: [],
		dragger: -1,
		
		/// materials
		mat_wood: new scr_item_class("Wood", spr_items, 40),
		mat_leaf: new scr_item_class("Leaf", spr_items, 45),
		mat_rock: new scr_item_class("Rock", spr_items, 12),
		mat_gold: new scr_item_class("Gold", spr_items, 8),
		mat_berries: new scr_item_class("Berries", spr_items, 56, statscript_potion, new scr_stats_class(10, 0, 0), "Heals 10 HP"),
		mat_meat: new scr_item_class("Meat", spr_items, 10, statscript_potion, new scr_stats_class(5, 0, 0), "Heals 5 HP"),
		mat_fish: new scr_item_class("Fish", spr_items, 58, statscript_potion, new scr_stats_class(25, 0, 0), "Heals 25 HP"),
		mat_potion: new scr_item_class("Healing Potion", spr_bag_items, 18, statscript_potion, new scr_stats_class(10, 0, 0), "Restores 10 HP"),
		
		/// key
		item_key: new scr_item_class("Key", spr_key, 0),
		
		/// plants
		food_carrot: new scr_item_class("Carrot", spr_food, 0, statscript_potion, new scr_stats_class(25, 0, 0), "Heals 25 HP"),
		seed_carrot: -1,
		
		/// buildings
		wall_grass: new scr_item_class("Grass Wall", spr_build_wall, 1, scr_place_building),
		floor_grass: new scr_item_class("Grass Floor", spr_build_floor, 1, scr_place_floor),
		floor_soil: new scr_item_class("Soil", spr_soil, 0, scr_place_dirt),
		
		/// recipes
		rec_wall_grass: -1,
		rec_floor_grass: -1,
		rec_floor_soil: -1,
		
		/// sprites for monsters
		mon_sprites: [],
		mon_names: [],
		
		/// bag names
		bag_items: 0,
		bag_recipes: 0,
		
		/// tooltip
		tooltips: new scr_tooltips_class(),
		
		//
		//base_font: font_add_sprite_ext(spr_font_16px, "abcdefghijklmnopqrstuvwxyz1234567890", true, -1)
	}

	audio_emitter_gain(global.CONTROLLER.SEemitter, global.CONFIG.sound_volume);
	audio_emitter_gain(global.CONTROLLER.MUSemitter, global.CONFIG.music_volume);
	audio_emitter_gain(global.CONTROLLER.BattleMUS, global.CONFIG.music_volume);
	
	//==================================== Recipe Creation =========================================================================//
	/// recipe to create wall grass
	global.CONTROLLER.rec_wall_grass = new scr_recipe_class("Grass Wall Recipe", [MAT_WOOD, MAT_LEAF], [1, 3], BUILD_WALL_GRASS, 2);
	/// recipe to create floor  grass
	global.CONTROLLER.rec_floor_grass = new scr_recipe_class("Grass Floor Recipe", [MAT_WOOD, MAT_LEAF], [2, 2], BUILD_FLOOR_GRASS, 1);
	/// recipe to create soil
	global.CONTROLLER.rec_floor_soil = new scr_recipe_class("Soil Recipe", [MAT_ROCK, MAT_LEAF], [2, 1], BUILD_FLOOR_SOIL, 3);
	
	//==================================== Seed creation ==========================================================================//
	// carrot seeds
	global.CONTROLLER.seed_carrot = new scr_seed_class("Carrot Seed", scr_build_plant_data("Carrot Plant", 60, spr_carrot, global.CONTROLLER.food_carrot, [1,1]), 0);
	
}
/// express global vars as macros for easy access
#macro KEY_UP global.CONFIG.up
#macro KEY_DOWN global.CONFIG.down
#macro KEY_LEFT global.CONFIG.left
#macro KEY_RIGHT global.CONFIG.right
#macro KEY_DELETE global.CONFIG.destroy
#macro KEY_EQUIP global.CONFIG.equip
#macro KEY_FORCE global.CONFIG.force
#macro SAVE_FILE "save.dat"
#macro MUSIC_VOL global.CONFIG.music_volume
#macro SOUND_VOL global.config.sound_volume
#macro MUSIC_EMIT global.CONTROLLER.MUSemitter
#macro SOUND_EMIT global.CONTROLLER.SEemitter
#macro CAMERA global.CONTROLLER.camera
#macro CAM_W global.CONFIG.view_width
#macro CAM_H global.CONFIG.view_height
#macro CAM_SCALE global.CONFIG.view_scale
#macro GAME_PAUSED global.CONTROLLER.game_paused
#macro WORLD_DATA global.CONFIG.world_data
#macro WORLD_SEEDS global.CONFIG.world_seeds
#macro WORLD_INDEX global.CONFIG.world_index
#macro WORLD_OBJECTS global.CONFIG.world_objects
#macro WORLD_SAVELIST global.CONTROLLER.savable_objects
#macro WORLD_READY global.CONTROLLER.world_ready
#macro CREATURE_SEEDS global.CONFIG.creature_list
#macro CREATURE_SPRITES global.CONTROLLER.mon_sprites
#macro CREATURE_NAMES global.CONTROLLER.mon_names
#macro TOOLTIPS global.CONTROLLER.tooltips
#macro CSTM_FONT fnt_default
//-------------------- World ----------------------------//
#macro INITIAL_LAND_SIZE 512

//------------------- STAT NAMES ------------------------//
#macro STAT_LIFE "life"
#macro STAT_DAMAGE "damage"
#macro STAT_SPEED "speed"
#macro STAT_ENERGY "energy"
#macro STAT_LEVEL global.CONFIG.level
#macro STAT_POINTS global.CONFIG.level_points
#macro STAT_EXP global.CONFIG.exp_amount
#macro EXP_MULT global.CONFIG.exp_multiplyer
#macro SKILL_DATA global.CONFIG.skill_data
#macro STAT_DATA global.CONFIG.player_stats
#macro PLAYER_SKILLS global.CONFIG.player_skills

//------------------ Bag Vars ----------------------//
#macro GUI_BLOCK_SIZE global.CONFIG.gui_block_size
#macro GUI_ITEM_SIZE global.CONFIG.gui_item_size
#macro BAG_ITEM_ID global.CONFIG.item_id
#macro BAG_SLOT_AMT global.CONTROLLER.slot_count
#macro BAG_SLOT_HOVER global.CONTROLLER.slot_hover
#macro BAG_SLOT_SELECT global.CONTROLLER.slot_selection
#macro BAG_PAUSED global.CONTROLLER.paused
#macro MENU_VIEW global.CONTROLLER.menu_view
#macro MENU_VIEW_GAME 0
#macro MENU_VIEW_INVENTORY 1
#macro MENU_VIEW_MAP 2
#macro MENU_VIEW_SKILLS 3
#macro BAG_ITEM_SLOTS global.CONTROLLER.item_slots
#macro BAG_TAB_SLOTS global.CONTROLLER.tab_slots
#macro BAG_TAB_COUNT global.CONTROLLER.tab_count
#macro BAG_GEAR_SEL global.CONTROLLER.gear_select
#macro BAG_GEAR_SLOT global.CONTROLLER.gear_slots
#macro BAG_GUI_DESC_BOX global.CONTROLLER.itm_desc_box
#macro BAG_PAUSE_POS global.CONTROLLER.pause_pos
#macro BAG_DRAGGER global.CONTROLLER.dragger
#macro PLAYER_BAG_CURRENT global.CONFIG.bag
#macro PLAYER_GEAR global.CONFIG.gear
#macro PLAYER_BAG_ITEMS global.CONTROLLER.bag_items
#macro PLAYER_BAG_RECIPES global.CONTROLLER.bag_recipes


//------------- materials -----------------//
#macro MAT_WOOD global.CONTROLLER.mat_wood
#macro MAT_LEAF global.CONTROLLER.mat_leaf
#macro MAT_ROCK global.CONTROLLER.mat_rock
#macro MAT_GOLD global.CONTROLLER.mat_gold
#macro MAT_BERRY global.CONTROLLER.mat_berries
#macro MAT_MEAT global.CONTROLLER.mat_meat
#macro MAT_FISH global.CONTROLLER.mat_fish
#macro MAT_POTION global.CONTROLLER.mat_potion

//-------------- misc items --------------//
#macro ITEM_KEY global.CONTROLLER.item_key

//-------------- buildings ---------------//
#macro BUILD_WALL_GRASS global.CONTROLLER.wall_grass
#macro BUILD_FLOOR_GRASS global.CONTROLLER.floor_grass
#macro BUILD_FLOOR_SOIL global.CONTROLLER.floor_soil

//--------------- Recipes ---------------//
#macro RECIPE_WALL_GRASS global.CONTROLLER.rec_wall_grass
#macro RECIPE_FLOOR_GRASS global.CONTROLLER.rec_floor_grass
#macro RECIPE_FLOOR_SOIL global.CONTROLLER.rec_floor_soil

/*
	======================================= Functions =========================================
*/
/// save config file
function scr_save_config(ind){
	var str = json_stringify(global.CONFIG);
	var encrypted = base64_encode(str);
	ini_open(SAVE_FILE);
	ini_write_string("Config", string(ind), encrypted);
	ini_close();
}

/// load a previously saved config file
function scr_load_config(ind){
	ini_open(SAVE_FILE);
	var load_data = ini_read_string("Config",string(ind), "");
	ini_close();
	if(load_data != ""){
		var decrypted = base64_decode(load_data);
		global.CONFIG = json_parse(decrypted);
	}
}

/// Use a fishing rod while facing a water tile. Fishing is a short stamina action with no minigame.
function scr_use_fishing_rod(item, bag){
	if(GAME_PAUSED) return false;
	var _player = instance_find(obj_player, 0);
	if(!scr_check_instance(_player)) return false;
	if(_player.fishing_cooldown > 0){
		scr_show_text_float(_player.x, _player.y - 20, "Wait for another bite", c_aqua);
		return false;
	}
	if(_player.stamina.value < 1){
		scr_show_text_float(_player.x, _player.y - 20, "Too tired to fish", c_white);
		return false;
	}
	var _sand_layer = layer_get_id("lay_sand");
	var _wall_layer = layer_get_id("lay_walls");
	if(_sand_layer < 0 || _wall_layer < 0) return false;
	var _sand_map = layer_tilemap_get_id(_sand_layer);
	var _wall_map = layer_tilemap_get_id(_wall_layer);
	var _cast_x = _player.x;
	var _cast_y = _player.y;
	var _range = 48;
	switch(_player.sprite_selection){
		case 0: _cast_x += _range; break;
		case 1: _cast_y -= _range; break;
		case 2: _cast_x -= _range; break;
		case 3: _cast_y += _range; break;
	}
	var _is_water = tilemap_get_at_pixel(_sand_map, _cast_x, _cast_y) <= 0
		&& tilemap_get_at_pixel(_wall_map, _cast_x, _cast_y) > 0;
	if(!_is_water){
		scr_show_text_float(_player.x, _player.y - 20, "Face the water to fish", c_aqua);
		return false;
	}
	_player.stamina.add(-1);
	_player.fishing_cooldown = room_speed * 2;
	if(random(1) < 0.65){
		scr_bag_add_item(bag, MAT_FISH, 1);
		scr_show_text_float(_player.x, _player.y - 20, "Fish caught!", c_aqua);
		scr_play_sound(snd_collect, 0);
	} else {
		scr_show_text_float(_player.x, _player.y - 20, "No bite this time", c_white);
	}
	return false;
}

/// play a sound effect
function scr_play_sound(sound_id, loop){
	if (audio_is_playing(sound_id)){
		audio_stop_sound(sound_id);
	}
	return audio_play_sound_on(SOUND_EMIT, sound_id, loop, 10);
}

/// play a music track
function scr_play_music(sound_id, loop){
	if (audio_is_playing(sound_id)){
		audio_stop_sound(sound_id);
	}
	return audio_play_sound_on(MUSIC_EMIT, sound_id, loop, 10);
}

/// set the volume of sound or music
function scr_set_volume(value, is_music=0){
	if(is_music){
		MUSIC_VOL = value;
		audio_emitter_gain(MUSIC_EMIT, MUSIC_VOL);
	} else {
		SOUND_VOL = value;
		audio_emitter_gain(SOUND_EMIT, SOUND_VOL);
	}
}

/// get current seed
function scr_get_current_seed(){
	return(WORLD_SEEDS[WORLD_INDEX]);
}

/// get current room
function scr_get_room_type(ind = WORLD_INDEX){
	return(WORLD_DATA.get_value(ind));
}

function scr_find_room_index(dx, dy){
	var pos = WORLD_DATA.region_array[WORLD_INDEX];
	var p2 = [pos[0]+dx, pos[1]+dy];
	var pos_next = WORLD_DATA.search(p2);
	return(pos_next);
}
