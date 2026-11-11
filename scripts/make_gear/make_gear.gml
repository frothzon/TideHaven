// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// @func make_gear(type);
/// @param {Real} type (_GEAR_)
/// @return {Struct} item
function make_gear(type=irandom(3), _seed=-1){
	
	if(_seed == -1){
		randomize();	
	} else {
		random_set_seed(_seed);
	}
	
	var bag = instance_find(obj_player_bag, 0);
	if(!scr_check_instance(bag)){
		return 0;
	}
	
	var _data = -1;
	if(type == _GEAR_.boots){
		var _stat = (random(0.1)+0.1) * STAT_LEVEL;
		var _things = ["Boots","Shoes","Slippers","Sneakers","Treads"];
		var _index = irandom(5);
		var _name = random_gear_name(_things[_index%array_length(_things)]);
		_data = new scr_gear_class(_name, spr_items_boots, _index, bag.equip_boots, -1,_stat,"speed");
	} else if(type == _GEAR_.shield){
		var _stat = (random(0.5)+0.5) * STAT_LEVEL;
		var _things = ["Shield","Barrier","Defender","Blocker","Guardian"];
		var _index = irandom(4);
		var _name = random_gear_name(_things[_index%array_length(_things)]);
		_data = new scr_gear_class(_name, spr_items_shield, _index, bag.equip_shield, -1,_stat,"damage");
	} else if(type == _GEAR_.helm){
		var _stat = (random(2)+2) * STAT_LEVEL;
		var _things = ["Hood","Helm","Noggin","Mitre","Dome","Cap","Bonnet"];
		var _index = irandom(8);
		var _name = random_gear_name(_things[_index%array_length(_things)]);
		_data = new scr_gear_class(_name, spr_items_helm, _index, bag.equip_helm, -1,_stat,"life");
	} else if(type == _GEAR_.chest){
		var _stat = (random(2)+2) * STAT_LEVEL;
		var _things = ["Breast","Chest","Body","Torso","Trunk"];
		var _index = irandom(4);
		var _name = random_gear_name(_things[_index%array_length(_things)]);
		_data = new scr_gear_class(_name, spr_items_chest, 0, bag.equip_chest, -1,_stat,"life");
	}
	
	if(is_struct(_data)){
		_data.seed = _seed;
		return _data;
	}
	return 0;
	/*
	STAT_LEVEL
	
	enum _GEAR_{
		boots,
		shield,
		helm,
		chest
	};
	
	equip_boots = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 0);
	equip_shield = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 1);
	equip_helm = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 2);
	equip_chest = scr_generate_equip_function(PLAYER_BAG_ITEMS, PLAYER_GEAR, 3);

	repeat(3){
		scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Worn Boots", spr_items_boots, 0, equip_boots, -1,random(0.1)+0.1,"speed"), 1);
	}
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Rusty Shield", spr_items_shield, 0, equip_shield, -1,1,"damage"), 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Iron Helm", spr_items_helm, 0, equip_helm, -1,2,"life"), 1);
	scr_bag_add_item(PLAYER_BAG_ITEMS, new scr_gear_class("Chest Plate", spr_items_chest, 0, equip_chest, -1,3,"life"), 1);
	*/
}

