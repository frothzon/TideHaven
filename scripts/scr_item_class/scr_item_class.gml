// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_item_class(_name, _sprite, _index, _script = -1, _data=-1, _desc = "") constructor{
	name = _name;
	type = ITEM_TYPE.material;
	sprite = _sprite;
	index = _index;
	use_item = _script;
	data = _data;
	desc = _desc;
	xdraw = 0;
	ydraw = 0;
	snap = true;
	seed = -1;
	id = _name;
	/// for drawing custom text for items
	toString = function(){
		var txt = desc == "" ? "#5"+name+"#0" : "#5"+name+"#0\n" + desc;
		return(txt);	
	}
}

/// extend item with gear class
function scr_gear_class(_name, _sprite, _index, _equip_script, _attack_script, _statvalue=1,_statText="Damage") : scr_item_class(_name, _sprite, _index, _equip_script, _statvalue) constructor{
	use_gear = _attack_script;
	use_ptr = _equip_script;
	type = ITEM_TYPE.bag;
	id = BAG_ITEM_ID++;
	data_type = _statText;
	xdraw = 0;
	ydraw = 0;
	snap = true;
	seed = -1;
	/// override use itme function to call use ptr built in function that contains reference to PLAYER_BAG, inventory slot, and index
	use_item = function(_ITEM_){
		use_ptr.run(_ITEM_);
	};
	toString = function(){
		txt = "#5"+name+"#0";
		if(!is_array(data)){
			txt +=  "\n" + data_type + ": " + string(data);
		} else {
			var len = array_length(data);
			for(var i = 0; i < len; i++){
				txt += "\n" + data_type[i] + ": " + string(data[i]);
			}
		}
		return(txt);
	}
}

/// extend gear with tool class
function scr_tool_class(_name, _sprite, _index, _tool_type, _equip_script, _attack_script, _statvalue=1, _statText="Damage") : scr_item_class(_name, _sprite, _index, _equip_script, _statvalue) constructor{
	tool_type = _tool_type;
	use_gear = _attack_script;
	use_ptr = _equip_script;
	type = ITEM_TYPE.tool;
	id = BAG_ITEM_ID++;
	data_type = _statText;
	xdraw = 0;
	ydraw = 0;
	snap = true;
	seed = -1;
	/// override use itme function to call use ptr built in function that contains reference to PLAYER_BAG, inventory slot, and index
	use_item = function(_ITEM_){
		use_ptr.run(_ITEM_);
	};
	toString = function(){
		txt = "#5"+name+"#0";
		if(!is_array(data)){
			txt +=  "\n" + data_type + ": " + string(data);
		} else {
			var len = array_length(data);
			for(var i = 0; i < len; i++){
				txt += "\n" + data_type[i] + ": " + string(data[i]);
			}
		}
		return(txt);
	}
}

function scr_recipe_class(_name, _itemList, _qtyList, _dropItem, _ind=0) constructor{
	name = _name;
	sprite = spr_recipe;
	index = _ind;
	type = ITEM_TYPE.recipe;
	use_item = scr_use_recipe;
	xdraw = 0;
	ydraw = 0;
	snap = true;
	seed = -1;
	can_craft = false;
	data = {
		items: _itemList, 
		amount: _qtyList,
		drop: _dropItem
	};
	id = BAG_ITEM_ID++;
	toString = function(){
		var txt = scr_concat("#5"+name+"#0","\nIngredients:\n");
		var len = array_length(data.items);
		var item_counter = scr_check_recipe(self);
		can_craft = true;
		for(var i = 0; i < len; i++){
			var have = item_counter[i];
			var color = have >= data.amount[i] ? "#g" : "#r";
			if(have < data.amount[i]){
				can_craft = false;
			}
			txt += 	scr_concat(data.items[i].name," x", data.amount[i], "(", color, have,"#w)");
			if(i < len-1) txt += "\n";
		}
		return(txt);
	}
}

function scr_seed_class(_name, _plant_data, _ind=0) constructor{
	name = _name;
	sprite = spr_seeds;
	index = _ind;
	type = ITEM_TYPE.seed;
	use_item = scr_use_seed;
	data = _plant_data;
	xdraw = 0;
	ydraw = 0;
	snap = true;
	seed = -1;
	id = BAG_ITEM_ID++;
	toString = function(){
		var txt = "#5"+name+"#0" + ", grows a " + data.name + "\nThey drop at most " + string(data.range[1]) + " item.";
		return(txt);	
	}
}

enum ITEM_TYPE{
	material,
	bag,
	recipe,
	seed,
	tool
};
