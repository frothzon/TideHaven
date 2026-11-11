/// @description move to mouse for placement

if(variable_instance_exists(id, "housing_template_preview") && housing_template_preview){
	var _template_count = array_length(global.CONFIG.housing_templates);
	if(template_index < 0 || template_index >= _template_count){
		global.CONFIG.housing_template_active = false;
		GAME_PAUSED = false;
		instance_destroy();
		exit;
	}
	var _template = global.CONFIG.housing_templates[template_index];
	var _preview_x = ((mouse_x >> 4) << 4) + 8;
	var _preview_y = ((mouse_y >> 4) << 4) + 16;
	var _valid = scr_housing_template_fits(_template, _preview_x, _preview_y, id)
		&& is_array(scr_housing_template_costs(_template, PLAYER_BAG_ITEMS));
	var _was_preview = mode == 0;
	scr_update_builder(-4, false, false, false, !_valid);
	if(life.value <= 0){
		global.CONFIG.housing_template_active = false;
		GAME_PAUSED = false;
		instance_destroy();
		exit;
	}
	if(_was_preview && mode != 0){
		if(_valid && scr_place_housing_template(_template, x, y, PLAYER_BAG_ITEMS, id)){
			scr_show_text_float(x, y - 20, "Placed " + _template.name, c_lime);
		} else {
			scr_show_text_float(x, y - 20, "Cannot place house here", c_yellow);
		}
		global.CONFIG.housing_template_active = false;
		instance_destroy();
		exit;
	}
	exit;
}

if(variable_instance_exists(id, "bridge_mode") && bridge_mode){
	var _was_preview = mode == 0;
	scr_update_builder(-4, false, false, false, undefined, "water");
	if(_was_preview && mode != 0 && life.value > 0){
		if(!scr_place_bridge_tile(id)){
			GAME_PAUSED = false;
			scr_bag_add_item(PLAYER_BAG_ITEMS, item, 1);
			instance_destroy();
		}
	}
} else {
	scr_update_builder(-4, false, false, true);
}
