// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


/// set up instance data object
function InstanceData (_instance) constructor {
	x = _instance.x;
	y = _instance.y;
	item = -1;
	plant = -1;
	xprevious = _instance.xprevious;
	yprevious = _instance.yprevious;
	depth = _instance.depth;
	object_index = _instance.object_index;
	
	static Create = function (){
		var _inst = instance_create_depth(x, y, depth, object_index);
		if(scr_check_instance(_inst)){
			_inst.xprevious = xprevious;
			_inst.yprevious = yprevious;
			_inst.item = item;
			_inst.plant = plant;
			scr_print(_inst, item);
			return(_inst);
		}
	}
}

function BuildingData (_instance) : InstanceData (_instance) constructor{
	item = _instance.item;
}

function PlantData (_instance) : BuildingData (_instance) constructor{
	plant = _instance.plant;
}


//================== Room Manager Object ================//
function scr_roomEndSaveState(){
	// Reset room data
	WORLD_OBJECTS[WORLD_INDEX] = [];

	// Save data
	var _objectCount = array_length(WORLD_SAVELIST);

	for (var i = 0; i < _objectCount; i ++) {
		var _object = WORLD_SAVELIST[i];
	
		with (_object) {
			var _data;
			if(variable_instance_exists(id, "plant")){
				_data = new PlantData(id);	// contains building data too
			} else if(variable_instance_exists(id, "item")){
				_data = new BuildingData(id);
			} else {
				_data = new InstanceData(id);
			}
			array_push(WORLD_OBJECTS[WORLD_INDEX], _data);
		}
	}
	scr_print(WORLD_OBJECTS[WORLD_INDEX], WORLD_INDEX);
}

function scr_roomStartLoadState(){
	// Load room data
	if (array_length(WORLD_OBJECTS) > WORLD_INDEX && array_length(WORLD_OBJECTS[WORLD_INDEX]) > 0) {
		// Remove all current instances
		var _objectCount = array_length(WORLD_SAVELIST);
	
		for (var i = 0; i < _objectCount; i ++) {
			instance_destroy(WORLD_SAVELIST[i]);
		}
	
		// Load instances
		var _roomData = WORLD_OBJECTS[WORLD_INDEX];
		var _instanceCount = array_length(_roomData);
		
		scr_print(WORLD_INDEX, _roomData);
	
		for (var i = 0; i < _instanceCount; i ++) {
			_roomData[i].Create();
		}
	}
}