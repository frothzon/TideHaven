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
		world_snapshot_saved: [],
		housing_templates: [],
		housing_template_index: 0,
		housing_template_active: false,
		current_area: "overworld",
		shrine_claimed: false,
		overworld_spawn: -1,
		overworld_gate_position: -1,
		tutorial_position: -1,
		overworld_guide_ready: false,
		dungeon_scene_objects: [],
		dungeon_saved_wall_cells: [],
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
			obj_builder_soil,
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
		water_bridge: new scr_item_class("Water Bridge", spr_build_floor, 0, scr_place_bridge, -1, "Place on water to make a walkable path"),
		
		/// recipes
		rec_wall_grass: -1,
		rec_floor_grass: -1,
		rec_floor_soil: -1,
		rec_water_bridge: -1,
		
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
	global.CONTROLLER.rec_water_bridge = new scr_recipe_class("Water Bridge Recipe", [MAT_WOOD, MAT_ROCK], [3, 1], BUILD_WATER_BRIDGE, 3);
	
	//==================================== Seed creation ==========================================================================//
	// carrot seeds
	global.CONTROLLER.seed_carrot = new scr_seed_class("Carrot Seed", scr_build_plant_data("Carrot Plant", 60, spr_carrot, global.CONTROLLER.food_carrot, [1,1]), 0);

	// Load only after the controller's item registry and world graph are ready.
	scr_load_game();
	
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
#macro SAVE_V2_FILE "TideHavenSave.json"
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
#macro WORLD_SNAPSHOT_SAVED global.CONFIG.world_snapshot_saved
#macro CURRENT_AREA global.CONFIG.current_area
#macro AREA_OVERWORLD "overworld"
#macro AREA_DUNGEON "dungeon"
#macro BIOME_COAST 0
#macro BIOME_GROVE 1
#macro BIOME_HIGHLAND 2
#macro DUNGEON_CENTER_X 3400
#macro DUNGEON_CENTER_Y 3300
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
#macro BUILD_WATER_BRIDGE global.CONTROLLER.water_bridge

//--------------- Recipes ---------------//
#macro RECIPE_WALL_GRASS global.CONTROLLER.rec_wall_grass
#macro RECIPE_FLOOR_GRASS global.CONTROLLER.rec_floor_grass
#macro RECIPE_FLOOR_SOIL global.CONTROLLER.rec_floor_soil
#macro RECIPE_WATER_BRIDGE global.CONTROLLER.rec_water_bridge

/*
	======================================= Functions =========================================
*/
/// Convert an item to a data-only record. Runtime methods and references are rebuilt on load.
function scr_save_item(_item){
	if(!is_struct(_item)) return -1;
	var _sprite_name = "";
	if(variable_struct_exists(_item, "sprite") && is_real(_item.sprite) && _item.sprite >= 0){
		_sprite_name = sprite_get_name(_item.sprite);
	}
	var _record = {
		name: variable_struct_exists(_item, "name") ? _item.name : "",
		type: variable_struct_exists(_item, "type") ? _item.type : ITEM_TYPE.material,
		sprite_name: _sprite_name,
		index: variable_struct_exists(_item, "index") ? _item.index : 0,
		id: variable_struct_exists(_item, "id") ? _item.id : "",
		data: -1,
		data_type: variable_struct_exists(_item, "data_type") ? _item.data_type : "",
		tool_type: variable_struct_exists(_item, "tool_type") ? _item.tool_type : -1,
		seed: variable_struct_exists(_item, "seed") ? _item.seed : -1
	};
	if(_record.type == ITEM_TYPE.bag || _record.type == ITEM_TYPE.tool){
		if(variable_struct_exists(_item, "data") && (is_real(_item.data) || is_string(_item.data) || is_array(_item.data))){
			_record.data = _item.data;
		}
	}
	return _record;
}

function scr_save_bag(_bag){
	var _items = [];
	var _amounts = [];
	var _count = array_length(_bag.items);
	for(var i = 0; i < _count; i++){
		_items[i] = scr_save_item(_bag.items[i]);
		_amounts[i] = _bag.amount[i];
	}
	return {name: _bag.name, resizable: _bag.resizable, items: _items, amount: _amounts};
}

function scr_convert_legacy_bag(_bag){
	if(!is_struct(_bag) || !variable_struct_exists(_bag, "items") || !is_array(_bag.items)) return -1;
	var _items = [];
	var _amounts = [];
	for(var i = 0; i < array_length(_bag.items); i++){
		_items[i] = scr_save_item(_bag.items[i]);
		_amounts[i] = is_array(_bag.amount) && i < array_length(_bag.amount) ? _bag.amount[i] : 0;
	}
	return {name: variable_struct_exists(_bag, "name") ? _bag.name : "Items", resizable: variable_struct_exists(_bag, "resizable") ? _bag.resizable : false, items: _items, amount: _amounts};
}

function scr_save_room_data(){
	var _rooms = [];
	var _room_count = array_length(WORLD_OBJECTS);
	for(var r = 0; r < _room_count; r++){
		_rooms[r] = [];
		if(is_array(WORLD_OBJECTS[r])){
			for(var i = 0; i < array_length(WORLD_OBJECTS[r]); i++){
				var _entry = WORLD_OBJECTS[r][i];
				if(is_struct(_entry) && variable_struct_exists(_entry, "object_name")){
					_rooms[r][i] = _entry;
				}
			}
		}
	}
	return _rooms;
}

function scr_save_world_graph(){
	var _grid = WORLD_DATA.grid;
	var _width = ds_grid_width(_grid);
	var _height = ds_grid_height(_grid);
	var _cells = [];
	for(var _gy = 0; _gy < _height; _gy++){
		for(var _gx = 0; _gx < _width; _gx++){
			array_push(_cells, _grid[# _gx, _gy]);
		}
	}
	return {
		width: _width,
		height: _height,
		cells: _cells,
		room_count: WORLD_DATA.room_count,
		region_array: WORLD_DATA.region_array,
		room_edge_array: WORLD_DATA.room_edge_array
	};
}

function scr_save_game(){
	var _player = instance_find(obj_player, 0);
	var _bag_obj = instance_find(obj_player_bag, 0);
	if(!scr_check_instance(_player) || !scr_check_instance(_bag_obj)) return false;

	backup_stats();
	var _bags = [];
	for(var b = 0; b < array_length(_bag_obj.bag_list); b++){
		_bags[b] = scr_save_bag(_bag_obj.bag_list[b]);
	}
	var _saved_gear = scr_save_bag(PLAYER_GEAR);
	var _grid_save = scr_save_world_graph();
	var _saved_world_ready = array_create(array_length(WORLD_SNAPSHOT_SAVED), false);
	for(var w = 0; w < array_length(WORLD_SNAPSHOT_SAVED); w++) _saved_world_ready[w] = WORLD_SNAPSHOT_SAVED[w];
	var _payload = {
		version: 1,
		world_seeds: WORLD_SEEDS,
		creature_seeds: CREATURE_SEEDS,
		world_index: WORLD_INDEX,
		world_graph: _grid_save,
		world_objects: scr_save_room_data(),
		world_snapshot_saved: _saved_world_ready,
		housing_templates: global.CONFIG.housing_templates,
		housing_template_index: global.CONFIG.housing_template_index,
		current_area: CURRENT_AREA,
		shrine_claimed: global.CONFIG.shrine_claimed,
		overworld_spawn: global.CONFIG.overworld_spawn,
		overworld_gate_position: global.CONFIG.overworld_gate_position,
		tutorial_position: global.CONFIG.tutorial_position,
		level: STAT_LEVEL,
		level_points: STAT_POINTS,
		exp_amount: STAT_EXP.export(),
		exp_multiplier: EXP_MULT,
		player_stats: STAT_DATA,
		player_skills: PLAYER_SKILLS,
		skill_data: SKILL_DATA,
		item_id: BAG_ITEM_ID,
		bag_index: _bag_obj.bag_index,
		bags: _bags,
		gear: _saved_gear,
		player: {x: _player.x, y: _player.y, sprite_selection: _player.sprite_selection}
	};
	var _json = json_stringify(_payload);
	var _temp_file = SAVE_V2_FILE + ".tmp";
	var _file = file_text_open_write(_temp_file);
	if(_file < 0) return false;
	file_text_write_string(_file, _json);
	file_text_close(_file);
	var _backup_file = SAVE_V2_FILE + ".bak";
	if(file_exists(_backup_file)) file_delete(_backup_file);
	if(file_exists(SAVE_V2_FILE)) file_rename(SAVE_V2_FILE, _backup_file);
	if(!file_rename(_temp_file, SAVE_V2_FILE)){
		if(!file_exists(SAVE_V2_FILE) && file_exists(_backup_file)) file_rename(_backup_file, SAVE_V2_FILE);
		return false;
	}
	show_debug_message("TideHaven save written.");
	global.PENDING_SAVE = _payload;
	return true;
}

function scr_apply_saved_world_graph(_graph){
	if(!is_struct(_graph) || !variable_struct_exists(_graph, "cells")) return;
	var _width = min(ds_grid_width(WORLD_DATA.grid), _graph.width);
	var _height = min(ds_grid_height(WORLD_DATA.grid), _graph.height);
	for(var _gy = 0; _gy < _height; _gy++){
		for(var _gx = 0; _gx < _width; _gx++){
			var _index = _gy * _graph.width + _gx;
			if(_index < array_length(_graph.cells)) WORLD_DATA.grid[# _gx, _gy] = _graph.cells[_index];
		}
	}
	WORLD_DATA.room_count = _graph.room_count;
	WORLD_DATA.region_array = _graph.region_array;
	WORLD_DATA.room_edge_array = _graph.room_edge_array;
}

function scr_apply_saved_config(_data){
	if(!is_struct(_data)) return false;
	if(variable_struct_exists(_data, "world_seeds") && is_array(_data.world_seeds)) WORLD_SEEDS = _data.world_seeds;
	if(variable_struct_exists(_data, "creature_seeds") && is_array(_data.creature_seeds)) CREATURE_SEEDS = _data.creature_seeds;
	if(variable_struct_exists(_data, "world_index")) WORLD_INDEX = max(0, _data.world_index);
	if(variable_struct_exists(_data, "world_graph")) scr_apply_saved_world_graph(_data.world_graph);
	if(variable_struct_exists(_data, "world_objects") && is_array(_data.world_objects)) WORLD_OBJECTS = _data.world_objects;
	if(variable_struct_exists(_data, "world_snapshot_saved") && is_array(_data.world_snapshot_saved)) WORLD_SNAPSHOT_SAVED = _data.world_snapshot_saved;
	if(variable_struct_exists(_data, "housing_templates") && is_array(_data.housing_templates)) global.CONFIG.housing_templates = _data.housing_templates;
	if(variable_struct_exists(_data, "housing_template_index")) global.CONFIG.housing_template_index = max(0, _data.housing_template_index);
	if(variable_struct_exists(_data, "current_area")) CURRENT_AREA = _data.current_area;
	if(variable_struct_exists(_data, "shrine_claimed")) global.CONFIG.shrine_claimed = _data.shrine_claimed;
	if(variable_struct_exists(_data, "overworld_spawn")) global.CONFIG.overworld_spawn = _data.overworld_spawn;
	if(variable_struct_exists(_data, "overworld_gate_position")) global.CONFIG.overworld_gate_position = _data.overworld_gate_position;
	if(variable_struct_exists(_data, "tutorial_position")) global.CONFIG.tutorial_position = _data.tutorial_position;
	if(variable_struct_exists(_data, "level")) STAT_LEVEL = _data.level;
	if(variable_struct_exists(_data, "level_points")) STAT_POINTS = _data.level_points;
	if(variable_struct_exists(_data, "exp_amount") && is_struct(_data.exp_amount)) STAT_EXP.import(_data.exp_amount);
	if(variable_struct_exists(_data, "exp_multiplier")) EXP_MULT = _data.exp_multiplier;
	if(variable_struct_exists(_data, "player_stats") && is_struct(_data.player_stats)) STAT_DATA = _data.player_stats;
	if(variable_struct_exists(_data, "player_skills") && is_struct(_data.player_skills)) PLAYER_SKILLS = _data.player_skills;
	if(variable_struct_exists(_data, "skill_data") && is_array(_data.skill_data)) SKILL_DATA = _data.skill_data;
	if(variable_struct_exists(_data, "item_id")) BAG_ITEM_ID = _data.item_id;
	global.PENDING_SAVE = _data;
	show_debug_message($"Loaded TideHaven save version {_data.version}.");
	return true;
}

function scr_load_game(){
	global.PENDING_SAVE = undefined;
	var _loaded = false;
	var _candidates = [SAVE_V2_FILE, SAVE_V2_FILE + ".bak"];
	for(var i = 0; i < array_length(_candidates) && !_loaded; i++){
		if(!file_exists(_candidates[i])) continue;
		var _file = file_text_open_read(_candidates[i]);
		if(_file < 0) continue;
		var _json = file_text_read_string(_file);
		file_text_close(_file);
		try {
			var _data = json_parse(_json);
			if(is_struct(_data) && variable_struct_exists(_data, "version") && _data.version >= 1){
				_loaded = scr_apply_saved_config(_data);
			}
		} catch (_error) {
			show_debug_message("Could not read TideHaven save; trying recovery copy.");
		}
	}

	// Migrate the former INI/base64 save without replacing it. Only fields that can be reconstructed safely are copied.
	if(!_loaded && file_exists(SAVE_FILE)){
		ini_open(SAVE_FILE);
		var _legacy = ini_read_string("Config", "0", "");
		ini_close();
		if(_legacy != ""){
			try {
				var _old = json_parse(base64_decode(_legacy));
				if(is_struct(_old)){
					if(variable_struct_exists(_old, "world_seeds")) WORLD_SEEDS = _old.world_seeds;
					if(variable_struct_exists(_old, "creature_list")) CREATURE_SEEDS = _old.creature_list;
					if(variable_struct_exists(_old, "world_index")) WORLD_INDEX = max(0, _old.world_index);
					if(variable_struct_exists(_old, "level")) STAT_LEVEL = _old.level;
					if(variable_struct_exists(_old, "level_points")) STAT_POINTS = _old.level_points;
					if(variable_struct_exists(_old, "exp_amount") && is_struct(_old.exp_amount)) STAT_EXP.import(_old.exp_amount);
					if(variable_struct_exists(_old, "player_stats")) STAT_DATA = _old.player_stats;
					if(variable_struct_exists(_old, "skill_data")) SKILL_DATA = _old.skill_data;
					if(variable_struct_exists(_old, "player_skills")) PLAYER_SKILLS = _old.player_skills;
					var _legacy_bags = array_create(2, -1);
					if(variable_struct_exists(_old, "bag")){
						var _legacy_bag = scr_convert_legacy_bag(_old.bag);
						if(is_struct(_legacy_bag)){
							var _bag_slot = _legacy_bag.name == "Recipes" ? 1 : 0;
							_legacy_bags[_bag_slot] = _legacy_bag;
						}
					}
					var _legacy_gear = variable_struct_exists(_old, "gear") ? scr_convert_legacy_bag(_old.gear) : -1;
					global.PENDING_SAVE = {bags: _legacy_bags, gear: _legacy_gear, bag_index: 0, player: {x: INITIAL_LAND_SIZE/2, y: INITIAL_LAND_SIZE/2, sprite_selection: 3}};
					_loaded = true;
					show_debug_message("Migrated legacy TideHaven progression. Save once to create the new format.");
				}
			} catch (_error) {
				show_debug_message("Legacy TideHaven save could not be migrated; starting with defaults.");
			}
		}
	}
	return _loaded;
}

function scr_load_item(_saved, _bag_obj){
	if(!is_struct(_saved) || !variable_struct_exists(_saved, "name")) return -1;
	var _known = [MAT_WOOD, MAT_LEAF, MAT_ROCK, MAT_GOLD, MAT_BERRY, MAT_MEAT, MAT_FISH, MAT_POTION, ITEM_KEY,
		global.CONTROLLER.food_carrot, global.CONTROLLER.seed_carrot, BUILD_WALL_GRASS, BUILD_FLOOR_GRASS, BUILD_FLOOR_SOIL, BUILD_WATER_BRIDGE,
		RECIPE_WALL_GRASS, RECIPE_FLOOR_GRASS, RECIPE_FLOOR_SOIL, RECIPE_WATER_BRIDGE];
	for(var i = 0; i < array_length(_known); i++){
		var _item = _known[i];
		if(is_struct(_item) && _item.name == _saved.name && _item.type == _saved.type) return _item;
	}
	for(var b = 0; b < array_length(_bag_obj.bag_list); b++){
		var _existing_bag = _bag_obj.bag_list[b];
		for(var j = 0; j < array_length(_existing_bag.items); j++){
			var _item = _existing_bag.items[j];
			if(is_struct(_item) && _item.name == _saved.name && _item.type == _saved.type) return _item;
		}
	}

	var _sprite = -1;
	if(variable_struct_exists(_saved, "sprite_name") && _saved.sprite_name != "") _sprite = asset_get_index(_saved.sprite_name);
	else if(variable_struct_exists(_saved, "sprite") && is_real(_saved.sprite)) _sprite = _saved.sprite;
	var _frame = variable_struct_exists(_saved, "index") ? _saved.index : 0;
	var _data = variable_struct_exists(_saved, "data") ? _saved.data : -1;
	var _data_type = variable_struct_exists(_saved, "data_type") ? _saved.data_type : "Damage";
	var _result = -1;
	if(_saved.type == ITEM_TYPE.tool){
		if(_sprite < 0) _sprite = spr_bag_items;
		var _tool_type = variable_struct_exists(_saved, "tool_type") ? _saved.tool_type : 0;
		_result = new scr_tool_class(_saved.name, _sprite, _frame, _tool_type, _bag_obj.equip_weapon, -1, _data, _data_type);
	} else if(_saved.type == ITEM_TYPE.bag){
		var _equip_fn = _bag_obj.equip_weapon;
		if(_saved.sprite_name == "spr_items_boots") _equip_fn = _bag_obj.equip_boots;
		else if(_saved.sprite_name == "spr_items_shield") _equip_fn = _bag_obj.equip_shield;
		else if(_saved.sprite_name == "spr_items_helm") _equip_fn = _bag_obj.equip_helm;
		else if(_saved.sprite_name == "spr_items_chest") _equip_fn = _bag_obj.equip_chest;
		if(_sprite < 0) _sprite = spr_items;
		_result = new scr_gear_class(_saved.name, _sprite, _frame, _equip_fn, -1, _data, _data_type);
	} else {
		if(_sprite < 0) _sprite = spr_items;
		_result = new scr_item_class(_saved.name, _sprite, _frame);
	}
	if(is_struct(_result) && variable_struct_exists(_saved, "id")) _result.id = _saved.id;
	if(is_struct(_result) && variable_struct_exists(_saved, "seed")) _result.seed = _saved.seed;
	if(is_real(_saved.id)) BAG_ITEM_ID = max(BAG_ITEM_ID, _saved.id + 1);
	return _result;
}

function scr_load_bag(_record, _bag_obj){
	if(!is_struct(_record) || !variable_struct_exists(_record, "items") || !is_array(_record.items)) return -1;
	var _name = variable_struct_exists(_record, "name") ? _record.name : "bag";
	var _loaded = scr_bag_create(array_length(_record.items), _name);
	_loaded.resizable = variable_struct_exists(_record, "resizable") ? _record.resizable : false;
	for(var i = 0; i < array_length(_record.items); i++){
		var _saved = _record.items[i];
		if(is_struct(_saved)) _loaded.items[i] = scr_load_item(_saved, _bag_obj);
		if(is_array(_record.amount) && i < array_length(_record.amount)) _loaded.amount[i] = max(0, _record.amount[i]);
	}
	return _loaded;
}

function scr_copy_bag_state(_target, _source){
	_target.name = _source.name;
	_target.resizable = _source.resizable;
	_target.items = _source.items;
	_target.amount = _source.amount;
}

function scr_apply_pending_inventory(_bag_obj){
	if(!is_struct(global.PENDING_SAVE)) return;
	var _pending = global.PENDING_SAVE;
	if(variable_struct_exists(_pending, "bags") && is_array(_pending.bags)){
		for(var i = 0; i < min(array_length(_pending.bags), array_length(_bag_obj.bag_list)); i++){
			var _loaded = scr_load_bag(_pending.bags[i], _bag_obj);
			if(is_struct(_loaded)) scr_copy_bag_state(_bag_obj.bag_list[i], _loaded);
		}
		_bag_obj.bag_index = clamp(variable_struct_exists(_pending, "bag_index") ? _pending.bag_index : 0, 0, array_length(_bag_obj.bag_list) - 1);
		PLAYER_BAG_CURRENT = _bag_obj.bag_list[_bag_obj.bag_index];
		PLAYER_BAG_ITEMS = _bag_obj.bag_list[0];
		PLAYER_BAG_RECIPES = _bag_obj.bag_list[1];
	}
	// Introduced after older saves were created; grant it once without duplicating it.
	if(scr_bag_search(PLAYER_BAG_RECIPES, RECIPE_WATER_BRIDGE, "name") < 0){
		scr_bag_add_item(PLAYER_BAG_RECIPES, RECIPE_WATER_BRIDGE, 1, true);
	}
	if(variable_struct_exists(_pending, "gear") && is_struct(_pending.gear)){
		var _loaded_gear = scr_load_bag(_pending.gear, _bag_obj);
		if(is_struct(_loaded_gear)) scr_copy_bag_state(PLAYER_GEAR, _loaded_gear);
	}
}

function scr_apply_pending_player(_player){
	if(!is_struct(global.PENDING_SAVE) || !variable_struct_exists(global.PENDING_SAVE, "player")) return;
	var _saved = global.PENDING_SAVE.player;
	if(!is_struct(_saved)) return;
	if(variable_struct_exists(_saved, "x")) _player.x = _saved.x;
	if(variable_struct_exists(_saved, "y")) _player.y = _saved.y;
	if(variable_struct_exists(_saved, "sprite_selection")) _player.sprite_selection = clamp(_saved.sprite_selection, 0, 3);
}

function scr_ensure_overworld_guide(){
	if(CURRENT_AREA != AREA_OVERWORLD || global.CONFIG.overworld_guide_ready) return;
	var _player = instance_find(obj_player, 0);
	var _world = instance_find(perlin_world, 0);
	if(!scr_check_instance(_player) || !scr_check_instance(_world)) return;

	var _has_gate = false;
	with(obj_npc_parent){
		if(variable_instance_exists(id, "dungeon_gate") && dungeon_gate){
			_has_gate = true;
			interaction_range = 64;
			depth = -1000;
		}
	}
	if(!_has_gate){
		var _position = global.CONFIG.overworld_gate_position;
		if(is_struct(_position) && point_distance(_player.x, _player.y, _position.x, _position.y) > 256){
			_position = -1;
			global.CONFIG.overworld_gate_position = -1;
		}
		if(!is_struct(_position)){
			var _offsets = [];
			var _rings = [128,144,160,176,192];
			for(var r = 0; r < array_length(_rings); r++){
				var d = _rings[r];
				array_push(_offsets, [d,0], [-d,0], [0,d], [0,-d], [d,d], [-d,d], [d,-d], [-d,-d]);
			}
			for(var i = 0; i < array_length(_offsets); i++){
				var _x = _player.x + _offsets[i][0];
				var _y = _player.y + _offsets[i][1];
				var _cell = _world.position_to_grid(_x, _y);
				if(_cell.x >= 0 && _cell.y >= 0 && _cell.x < ds_grid_width(_world.grid[0]) && _cell.y < ds_grid_height(_world.grid[0])
				&& ds_grid_get(_world.grid[0], _cell.x, _cell.y) > 0
				&& !scr_place_meeting_list(_x, _y, [obj_breakable_parent, obj_floor_parent, obj_player])){
					_position = {x: _x, y: _y};
					break;
				}
			}
			if(!is_struct(_position)) _position = {x: _player.x + 64, y: _player.y};
			global.CONFIG.overworld_gate_position = _position;
		}
		var _gate = instance_create_depth(_position.x, _position.y, 0, obj_npc_parent);
		_gate.dungeon_gate = true;
		_gate.interaction_range = 64;
		_gate.depth = -1000;
		_gate.sprite_index = spr_door_locked;
	}

	var _has_guide = false;
	with(obj_npc_parent){
		if(variable_instance_exists(id, "tidehaven_guide") && tidehaven_guide){
			_has_guide = true;
			interaction_range = 64;
			image_xscale = 0.25;
			image_yscale = 0.25;
			depth = -1000;
		}
	}
	if(!_has_guide){
		var _guide_position = global.CONFIG.tutorial_position;
		if(is_struct(_guide_position) && point_distance(_player.x, _player.y, _guide_position.x, _guide_position.y) > 256){
			_guide_position = -1;
			global.CONFIG.tutorial_position = -1;
		}
		if(!is_struct(_guide_position)){
			_guide_position = {x: _player.x - 48, y: _player.y + 24};
			global.CONFIG.tutorial_position = _guide_position;
		}
		var _guide = instance_create_depth(_guide_position.x, _guide_position.y, 0, obj_npc_parent);
		_guide.tidehaven_guide = true;
		_guide.interaction_range = 64;
		_guide.image_xscale = 0.25;
		_guide.image_yscale = 0.25;
		_guide.depth = -1000;
		_guide.messages = [
			"Welcome to TideHaven. Move with WASD and use E to interact.",
			"Open the marked cave door near camp to begin the shrine trail.",
			"Follow the stone path. Press E at the shrine chest for a reward.",
			"The door at the start of the cave returns you here. P opens inventory; B opens skills."
		];
	}
	global.CONFIG.overworld_guide_ready = true;
}

function scr_ensure_dungeon_scene(){
	if(CURRENT_AREA != AREA_DUNGEON) return;
	var _exists = false;
	with(obj_world_generator){
		if(variable_instance_exists(id, "dungeon_scene") && dungeon_scene) _exists = true;
	}
	if(!_exists){
		global.CONFIG.dungeon_scene_objects = [];
		instance_create_depth(DUNGEON_CENTER_X, DUNGEON_CENTER_Y, -50, obj_world_generator);
	}
}

function scr_clear_dungeon_scene(){
	var _world = instance_find(perlin_world, 0);
	if(scr_check_instance(_world) && is_array(global.CONFIG.dungeon_saved_wall_cells)){
		for(var i = 0; i < array_length(global.CONFIG.dungeon_saved_wall_cells); i++){
			var _cell = global.CONFIG.dungeon_saved_wall_cells[i];
			tilemap_set(_world.map_walls, _cell.data, _cell.x, _cell.y);
		}
	}
	global.CONFIG.dungeon_saved_wall_cells = [];
	if(is_array(global.CONFIG.dungeon_scene_objects)){
		for(var i = 0; i < array_length(global.CONFIG.dungeon_scene_objects); i++){
			var _instance = global.CONFIG.dungeon_scene_objects[i];
			if(scr_check_instance(_instance)) instance_destroy(_instance);
		}
	}
	global.CONFIG.dungeon_scene_objects = [];
}

function scr_enter_dungeon(){
	if(CURRENT_AREA != AREA_OVERWORLD) return false;
	var _player = instance_find(obj_player, 0);
	if(!scr_check_instance(_player)) return false;
	scr_roomEndSaveState();
	global.CONFIG.overworld_spawn = {x: _player.x, y: _player.y, sprite_selection: _player.sprite_selection};
	CURRENT_AREA = AREA_DUNGEON;
	_player.x = DUNGEON_CENTER_X - 400;
	_player.y = DUNGEON_CENTER_Y;
	var _camera_lerp = CAMERA.lerpRatio;
	CAMERA.lerpRatio = 1;
	CAMERA.center_on_object(_player);
	CAMERA.update();
	CAMERA.lerpRatio = _camera_lerp;
	scr_ensure_dungeon_scene();
	scr_save_game();
	return true;
}

function scr_return_to_overworld(){
	if(CURRENT_AREA != AREA_DUNGEON) return false;
	var _player = instance_find(obj_player, 0);
	if(!scr_check_instance(_player)) return false;
	scr_clear_dungeon_scene();
	var _position = global.CONFIG.overworld_spawn;
	CURRENT_AREA = AREA_OVERWORLD;
	if(is_struct(_position)){
		_player.x = _position.x;
		_player.y = _position.y;
		if(variable_struct_exists(_position, "sprite_selection")) _player.sprite_selection = _position.sprite_selection;
	}
	var _camera_lerp = CAMERA.lerpRatio;
	CAMERA.lerpRatio = 1;
	CAMERA.center_on_object(_player);
	CAMERA.update();
	CAMERA.lerpRatio = _camera_lerp;
	scr_roomStartLoadState();
	scr_ensure_overworld_guide();
	scr_save_game();
	return true;
}

function scr_claim_dungeon_shrine(){
	if(global.CONFIG.shrine_claimed) return false;
	if(!scr_bag_add_item(PLAYER_BAG_ITEMS, MAT_POTION, 2)) return false;
	global.CONFIG.shrine_claimed = true;
	STAT_EXP.value += 15;
	scr_save_game();
	return true;
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

function scr_get_biome_at_position(_x, _y){
	var _world = instance_find(perlin_world, 0);
	if(!scr_check_instance(_world) || !variable_instance_exists(_world, "biome_grid")) return BIOME_GROVE;
	var _cell = _world.position_to_grid(_x, _y);
	if(_cell.x < 0 || _cell.y < 0 || _cell.x >= ds_grid_width(_world.biome_grid) || _cell.y >= ds_grid_height(_world.biome_grid)) return BIOME_GROVE;
	return ds_grid_get(_world.biome_grid, _cell.x, _cell.y);
}

function scr_apply_bridge_tile(_bridge){
	if(!scr_check_instance(_bridge) || !variable_instance_exists(_bridge, "bridge_mode") || !_bridge.bridge_mode || !is_struct(_bridge.bridge_cell)) return false;
	var _world = instance_find(perlin_world, 0);
	if(!scr_check_instance(_world)) return false;
	var _cell = _bridge.bridge_cell;
	return tilemap_set(_world.map_walls, 0, _cell.x, _cell.y);
}

function scr_restore_bridge_tile(_bridge){
	if(!scr_check_instance(_bridge) || !variable_instance_exists(_bridge, "bridge_mode") || !_bridge.bridge_mode || !is_struct(_bridge.bridge_cell)) return false;
	var _world = instance_find(perlin_world, 0);
	if(!scr_check_instance(_world)) return false;
	var _cell = _bridge.bridge_cell;
	var _restored = tilemap_set(_world.map_walls, _bridge.bridge_tile_data, _cell.x, _cell.y);
	_bridge.bridge_cell = -1;
	return _restored;
}

function scr_place_bridge_tile(_bridge){
	if(!scr_check_instance(_bridge) || !variable_instance_exists(_bridge, "bridge_mode") || !_bridge.bridge_mode) return false;
	var _world = instance_find(perlin_world, 0);
	if(!scr_check_instance(_world)) return false;
	var _cell = _world.position_to_grid(_bridge.x, _bridge.y);
	if(_cell.x < 0 || _cell.y < 0 || _cell.x >= ds_grid_width(_world.grid[0]) || _cell.y >= ds_grid_height(_world.grid[0])) return false;
	_bridge.bridge_tile_data = tilemap_get(_world.map_walls, _cell.x, _cell.y);
	_bridge.bridge_cell = _cell;
	return scr_apply_bridge_tile(_bridge);
}

function scr_add_housing_template_object(_records, _instance, _center_x, _center_y, _radius){
	if(!scr_check_instance(_instance) || !variable_instance_exists(_instance, "mode") || _instance.mode == 0) return _records;
	if(point_distance(_instance.x, _instance.y, _center_x, _center_y) > _radius) return _records;
	if(variable_instance_exists(_instance, "bridge_mode") && _instance.bridge_mode) return _records;
	var _sprite_name = _instance.sprite_index >= 0 ? sprite_get_name(_instance.sprite_index) : "";
	var _item_record = variable_instance_exists(_instance, "item") && is_struct(_instance.item) ? scr_save_item(_instance.item) : -1;
	array_push(_records, {
		object_name: object_get_name(_instance.object_index),
		sprite_name: _sprite_name,
		x_offset: _instance.x - _center_x,
		y_offset: _instance.y - _center_y,
		depth_offset: _instance.depth - _instance.y,
		image_index: _instance.image_index,
		image_xscale: _instance.image_xscale,
		image_yscale: _instance.image_yscale,
		image_angle: _instance.image_angle,
		image_blend: _instance.image_blend,
		item: _item_record
	});
	return _records;
}

function scr_capture_housing_template(_center_x, _center_y, _radius=128){
	if(CURRENT_AREA != AREA_OVERWORLD) return false;
	var _records = [];
	for(var i = 0; i < instance_number(obj_builder_floor); i++) _records = scr_add_housing_template_object(_records, instance_find(obj_builder_floor, i), _center_x, _center_y, _radius);
	for(var i = 0; i < instance_number(obj_builder_wall); i++) _records = scr_add_housing_template_object(_records, instance_find(obj_builder_wall, i), _center_x, _center_y, _radius);
	for(var i = 0; i < instance_number(obj_builder_soil); i++) _records = scr_add_housing_template_object(_records, instance_find(obj_builder_soil, i), _center_x, _center_y, _radius);
	if(array_length(_records) == 0) return false;
	var _template_number = array_length(global.CONFIG.housing_templates) + 1;
	var _template = {name: "House " + string(_template_number), cells: _records};
	array_push(global.CONFIG.housing_templates, _template);
	if(array_length(global.CONFIG.housing_templates) > 12){
		array_delete(global.CONFIG.housing_templates, 0, 1);
		_template_number--;
	}
	global.CONFIG.housing_template_index = array_length(global.CONFIG.housing_templates) - 1;
	if(scr_save_game()) scr_show_text_float(_center_x, _center_y - 20, "Saved " + _template.name, c_lime);
	return true;
}

function scr_housing_template_costs(_template, _bag){
	if(!is_struct(_template) || !variable_struct_exists(_template, "cells") || !is_array(_template.cells)) return -1;
	var _costs = [];
	for(var i = 0; i < array_length(_template.cells); i++){
		var _cell = _template.cells[i];
		if(!is_struct(_cell) || !variable_struct_exists(_cell, "item") || !is_struct(_cell.item) || !variable_struct_exists(_cell.item, "id")) continue;
		var _found = -1;
		for(var c = 0; c < array_length(_costs); c++) if(_costs[c].id == _cell.item.id){ _found = c; break; }
		if(_found >= 0){
			_costs[_found].count++;
		} else {
			var _bag_index = scr_bag_search(_bag, {id:_cell.item.id});
			if(_bag_index < 0) return -1;
			array_push(_costs, {id:_cell.item.id, item:_bag.items[_bag_index], count:1});
		}
	}
	for(var c = 0; c < array_length(_costs); c++){
		var _bag_index = scr_bag_search(_bag, {id:_costs[c].id});
		if(_bag_index < 0 || scr_bag_get_amount(_bag, _bag_index) < _costs[c].count) return -1;
	}
	return _costs;
}

function scr_housing_template_fits(_template, _x, _y, _ignore=noone){
	if(!is_struct(_template) || !variable_struct_exists(_template, "cells") || !is_array(_template.cells) || array_length(_template.cells) == 0) return false;
	for(var i = 0; i < array_length(_template.cells); i++){
		var _cell = _template.cells[i];
		if(!is_struct(_cell) || !variable_struct_exists(_cell, "object_name")) return false;
		if(_cell.object_name != "obj_builder_floor" && _cell.object_name != "obj_builder_wall" && _cell.object_name != "obj_builder_soil") return false;
		var _target_x = _x + _cell.x_offset;
		var _target_y = _y + _cell.y_offset;
		if(!scr_tile_at_position(_target_x, _target_y, "lay_sand")) return false;
		var _blocked = false;
		with(obj_breakable_parent) if(id != _ignore && point_in_circle(x, y, _target_x, _target_y, 12)) _blocked = true;
		with(obj_floor_parent) if(id != _ignore && point_in_circle(x, y, _target_x, _target_y, 12)) _blocked = true;
		if(_blocked) return false;
	}
	return true;
}

function scr_place_housing_template(_template, _x, _y, _bag, _ignore=noone){
	var _costs = scr_housing_template_costs(_template, _bag);
	if(!is_array(_costs) || !scr_housing_template_fits(_template, _x, _y, _ignore)) return false;
	for(var c = 0; c < array_length(_costs); c++) scr_bag_add_item(_bag, _costs[c].item, -_costs[c].count, true);
	var _bag_obj = instance_find(obj_player_bag, 0);
	for(var i = 0; i < array_length(_template.cells); i++){
		var _cell = _template.cells[i];
		var _object_index = asset_get_index(_cell.object_name);
		var _sprite_index = _cell.sprite_name != "" ? asset_get_index(_cell.sprite_name) : -1;
		var _target_x = _x + _cell.x_offset;
		var _target_y = _y + _cell.y_offset;
		var _instance = instance_create_depth(_target_x, _target_y, _target_y + _cell.depth_offset, _object_index);
		if(_sprite_index >= 0) _instance.sprite_index = _sprite_index;
		_instance.image_index = _cell.image_index;
		_instance.image_xscale = _cell.image_xscale;
		_instance.image_yscale = _cell.image_yscale;
		_instance.image_angle = _cell.image_angle;
		_instance.image_blend = _cell.image_blend;
		if(is_struct(_cell.item)) _instance.item = scr_load_item(_cell.item, _bag_obj);
	}
	scr_roomEndSaveState();
	scr_save_game();
	return true;
}

function scr_draw_housing_template_preview(_template, _x, _y, _valid){
	var _tint = _valid ? c_lime : c_red;
	draw_set_alpha(0.65);
	for(var i = 0; i < array_length(_template.cells); i++){
		var _cell = _template.cells[i];
		var _sprite = _cell.sprite_name != "" ? asset_get_index(_cell.sprite_name) : -1;
		if(_sprite >= 0) draw_sprite_ext(_sprite, _cell.image_index, _x + _cell.x_offset, _y + _cell.y_offset, _cell.image_xscale, _cell.image_yscale, _cell.image_angle, _tint, 0.65);
	}
	draw_set_alpha(1);
	scr_draw_reset();
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
