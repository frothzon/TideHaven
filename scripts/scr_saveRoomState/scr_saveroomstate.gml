// Room snapshots use stable resource names and data-only structs so they survive process restarts.
function scr_save_plant_data(_plant){
	if(!is_struct(_plant)) return -1;
	var _sprite_name = "";
	if(variable_struct_exists(_plant, "sprite") && is_real(_plant.sprite) && _plant.sprite >= 0){
		_sprite_name = sprite_get_name(_plant.sprite);
	}
	return {
		name: _plant.name,
		grow_time: _plant.grow_time,
		time_planted: _plant.time_planted,
		sprite_name: _sprite_name,
		index: _plant.index,
		range: _plant.range,
		state: _plant.state,
		ratio: _plant.ratio,
		drop: scr_save_item(_plant.drop)
	};
}

function scr_load_plant_data(_saved, _bag_obj){
	if(!is_struct(_saved)) return -1;
	var _sprite = asset_get_index(_saved.sprite_name);
	var _drop = scr_load_item(_saved.drop, _bag_obj);
	var _plant = scr_build_plant_data(_saved.name, _saved.grow_time, _sprite, _drop, _saved.range);
	_plant.time_planted = _saved.time_planted;
	_plant.index = _saved.index;
	_plant.state = _saved.state;
	_plant.ratio = _saved.ratio;
	return _plant;
}

function scr_roomEndSaveState(){
	if(WORLD_INDEX < 0) return;
	while(array_length(WORLD_OBJECTS) <= WORLD_INDEX) array_push(WORLD_OBJECTS, []);
	while(array_length(WORLD_SNAPSHOT_SAVED) <= WORLD_INDEX) array_push(WORLD_SNAPSHOT_SAVED, false);
	WORLD_OBJECTS[WORLD_INDEX] = [];
	WORLD_SNAPSHOT_SAVED[WORLD_INDEX] = true;

	for(var i = 0; i < array_length(WORLD_SAVELIST); i++){
		var _object = WORLD_SAVELIST[i];
		with(_object){
			var _record = {
				object_name: object_get_name(object_index),
				sprite_name: sprite_index >= 0 ? sprite_get_name(sprite_index) : "",
				x: x,
				y: y,
				xprevious: xprevious,
				yprevious: yprevious,
				depth: depth,
				image_index: image_index,
				image_speed: image_speed,
				image_xscale: image_xscale,
				image_yscale: image_yscale,
				image_angle: image_angle,
				image_alpha: image_alpha,
				image_blend: image_blend,
				item: -1,
				plant: -1,
				life: -1,
				drop_item_list: -1,
				drop_item_weights: -1,
				drop_quantities: -1
			};
			if(variable_instance_exists(id, "item")) _record.item = scr_save_item(item);
			if(variable_instance_exists(id, "plant")) _record.plant = scr_save_plant_data(plant);
			if(variable_instance_exists(id, "life") && is_struct(life)) _record.life = life.export();
			if(variable_instance_exists(id, "drop_item_list") && is_array(drop_item_list)){
				_record.drop_item_list = [];
				for(var d = 0; d < array_length(drop_item_list); d++) array_push(_record.drop_item_list, scr_save_item(drop_item_list[d]));
			}
			if(variable_instance_exists(id, "drop_item_weights") && is_array(drop_item_weights)) _record.drop_item_weights = drop_item_weights;
			if(variable_instance_exists(id, "drop_quantities") && is_array(drop_quantities)) _record.drop_quantities = drop_quantities;
			if(variable_instance_exists(id, "bridge_mode") && bridge_mode){
				_record.bridge_mode = true;
				_record.bridge_cell = bridge_cell;
				_record.bridge_tile_data = bridge_tile_data;
			}
			array_push(WORLD_OBJECTS[WORLD_INDEX], _record);
		}
	}
}

function scr_roomStartLoadState(){
	if(WORLD_INDEX < 0 || WORLD_INDEX >= array_length(WORLD_SNAPSHOT_SAVED) || !WORLD_SNAPSHOT_SAVED[WORLD_INDEX]) return;
	for(var i = 0; i < array_length(WORLD_SAVELIST); i++) instance_destroy(WORLD_SAVELIST[i]);
	var _room_data = WORLD_INDEX < array_length(WORLD_OBJECTS) ? WORLD_OBJECTS[WORLD_INDEX] : [];
	var _bag_obj = instance_find(obj_player_bag, 0);
	for(var i = 0; i < array_length(_room_data); i++){
		var _record = _room_data[i];
		if(!is_struct(_record) || !variable_struct_exists(_record, "object_name")) continue;
		var _object_index = asset_get_index(_record.object_name);
		var _allowed = false;
		for(var j = 0; j < array_length(WORLD_SAVELIST) && !_allowed; j++){
			var _ancestor = _object_index;
			while(_ancestor >= 0){
				if(_ancestor == WORLD_SAVELIST[j]){
					_allowed = true;
					break;
				}
				_ancestor = object_get_parent(_ancestor);
			}
		}
		if(!_allowed) continue;
		var _instance = instance_create_depth(_record.x, _record.y, _record.depth, _object_index);
		if(variable_struct_exists(_record, "sprite_name") && _record.sprite_name != ""){
			var _sprite = asset_get_index(_record.sprite_name);
			if(_sprite >= 0) _instance.sprite_index = _sprite;
		}
		_instance.xprevious = _record.xprevious;
		_instance.yprevious = _record.yprevious;
		_instance.image_index = _record.image_index;
		_instance.image_speed = _record.image_speed;
		_instance.image_xscale = _record.image_xscale;
		_instance.image_yscale = _record.image_yscale;
		_instance.image_angle = _record.image_angle;
		_instance.image_alpha = _record.image_alpha;
		_instance.image_blend = _record.image_blend;
		if(variable_instance_exists(_instance, "item") && is_struct(_record.item)) _instance.item = scr_load_item(_record.item, _bag_obj);
		if(variable_instance_exists(_instance, "plant") && is_struct(_record.plant)) _instance.plant = scr_load_plant_data(_record.plant, _bag_obj);
		if(variable_instance_exists(_instance, "life") && is_struct(_record.life)) _instance.life.import(_record.life);
		if(variable_instance_exists(_instance, "drop_item_list") && variable_struct_exists(_record, "drop_item_list") && is_array(_record.drop_item_list)){
			var _drops = [];
			for(var d = 0; d < array_length(_record.drop_item_list); d++) array_push(_drops, scr_load_item(_record.drop_item_list[d], _bag_obj));
			_instance.drop_item_list = _drops;
		}
		if(variable_instance_exists(_instance, "drop_item_weights") && variable_struct_exists(_record, "drop_item_weights") && is_array(_record.drop_item_weights)) _instance.drop_item_weights = _record.drop_item_weights;
		if(variable_instance_exists(_instance, "drop_quantities") && variable_struct_exists(_record, "drop_quantities") && is_array(_record.drop_quantities)) _instance.drop_quantities = _record.drop_quantities;
		if(variable_struct_exists(_record, "bridge_mode") && _record.bridge_mode){
			_instance.bridge_mode = true;
			_instance.bridge_cell = _record.bridge_cell;
			_instance.bridge_tile_data = _record.bridge_tile_data;
			scr_apply_bridge_tile(_instance);
		}
	}
}
