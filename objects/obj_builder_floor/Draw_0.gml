/// @description draw self

if(variable_instance_exists(id, "housing_template_preview") && housing_template_preview){
	if(template_index >= 0 && template_index < array_length(global.CONFIG.housing_templates)){
		var _template = global.CONFIG.housing_templates[template_index];
		var _valid = scr_housing_template_fits(_template, x, y, id)
			&& is_array(scr_housing_template_costs(_template, PLAYER_BAG_ITEMS));
		scr_draw_housing_template_preview(_template, x, y, _valid);
	}
	exit;
}

image_alpha = 1;
image_xscale = scaling.x;
image_yscale = scaling.y;

scr_draw_build_mode();
draw_self();

image_xscale = 1;
image_yscale = 1;
