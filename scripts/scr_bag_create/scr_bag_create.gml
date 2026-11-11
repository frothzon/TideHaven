/*
	create a PLAYER_BAG to hold items, and a PLAYER_BAG for equipped _GEAR_. All functions start with scr_bag_ for easy auto-complete searching
		
	scr_bag_create(count); returns a struct with the following properties:
		items: array of structs -- items must be structs that contain at least 1 element used as an ID
		amount: array of integer values keeping track of multiples of the same item
		resizable: whether the PLAYER_BAG grows to accomodate new items
		
	scr_bag_get_item(bag_obj, bag_index); returns the item (struct) at the specified index
	
	scr_bag_get_amount(bag_obj, bag_index); returns the item amount (real) at the specified index
	
	scr_bag_search(bag_obj, item_obj, identifier = "name"); returns the index of item (struct) with the matching identifier (internal variable) or -1 if not found
	
	scr_bag_find_empty_spot(bag_obj); returns first index with no entry or -1. If PLAYER_BAG is marked resizable, it gives next index outside of bounds
	
	scr_bag_cleanup(bag_obj); no value returned, function removes unused items (struct with 0 amount)
	
	scr_bag_add_item(bag_obj, item_obj, qty); Attemps to add item / amount to PLAYER_BAG. Can be negative (removing items) or positive. Returns true or false
		(If there are no slots available and PLAYER_BAG is marked non-resizable it will return false)
		
	scr_bag_swap_slots(bag_obj, indA, indB); Puts item/amount in PLAYER_BAG index B into PLAYER_BAG index A, then puts what was previously in index A into index B
		
*/

/// create a new PLAYER_BAG
function scr_bag_create(slot_count, _name="bag"){
	// PLAYER_BAG
	var _bag = {
		items: array_create(slot_count, -1),
		amount: array_create(slot_count, 0),
		resizable: false,
		name: _name 
	}
	return(_bag);
}

/// return item stored in the PLAYER_BAG at the position
function scr_bag_get_item(bag_obj, bag_index){
	if(bag_index < 0 || bag_index >= array_length(bag_obj.items)){
		return -1;	
	}
	return(bag_obj.items[bag_index]);
}

/// return item quantity in the PLAYER_BAG at the position
function scr_bag_get_amount(bag_obj, bag_index){
	if(bag_index < 0 || bag_index >= array_length(bag_obj.amount)){
		return 0;	
	}
	return(bag_obj.amount[bag_index]);	
}

/// search PLAYER_BAG for index of first instance occurence, check if the identifier matches one in the inventory
function scr_bag_search(bag_obj, item_obj, identifier = "id"){
	if(!variable_struct_exists(item_obj, identifier)){
		show_error("object identifier invalid", 0);
		return -1;
	}
	for(var i = 0; i < array_length(bag_obj.items); i++){
		if(is_struct(bag_obj.items[i]) && variable_struct_exists(bag_obj.items[i], identifier)){
			var bag_item_id = variable_struct_get(bag_obj.items[i], identifier);
			var item_id = variable_struct_get(item_obj, identifier);
			
			if(bag_item_id == item_id){
				return(i);
			}
		}
	}
	return(-1);
}

/// search PLAYER_BAG for an empty spot
function scr_bag_find_empty_spot(bag_obj){
	var size = array_length(bag_obj.items);
	for(var i = 0; i < size; i++){
		if(!is_struct(bag_obj.items[i])){
			return(i);
		}
	}
	if(bag_obj.resizable){
		return(size);
	}
	return(-1);
}

/// remove items from PLAYER_BAG with a quantity less than 1
function scr_bag_cleanup(bag_obj){
	for(var i = 0; i < array_length(bag_obj.items); i++){
		if(bag_obj.amount[i] <= 0 && is_struct(bag_obj.items[i])){
			delete bag_obj.items[i];
			bag_obj.items[i] = -1;
			bag_obj.amount[i] = 0;
			
		}
	}
}

/// add item to the PLAYER_BAG
function scr_bag_add_item(bag_obj, item_obj, qty, ignoreTip=false){
	var index = scr_bag_search(bag_obj, item_obj);
	var success = 0;
	if(index >= 0){
		//bag_obj.items[index] = item_obj;
		bag_obj.amount[index] += qty;
		success = 1;
	} else {
		index = scr_bag_find_empty_spot(bag_obj);
		if(index >= 0){
			bag_obj.items[index] = item_obj;
			bag_obj.amount[index] = qty;
			success = 1;
		}
	}
	scr_bag_cleanup(bag_obj);
	// add item
	if(success && !ignoreTip){
		if(qty > 0){
			/// adding
			scr_add_tooltip(TOOLTIPS, scr_concat("+",qty," ",item_obj.name), item_obj.sprite, item_obj.index, c_lime);
		} else {
			scr_add_tooltip(TOOLTIPS, scr_concat("Removed ",abs(qty)," ",item_obj.name), item_obj.sprite, item_obj.index, c_red);
		}
	}
	return(success);
}

// swap indices
function scr_bag_swap_slots(bag_objA, bag_objB, indA, indB){
	
	/// check if inside PLAYER_BAG bounds
	var lenA = array_length(bag_objA.items);
	var lenB = array_length(bag_objB.items);
	if(indA < 0 || indB < 0 || indA >= lenA || indB >= lenB){
		show_debug_message(["a, b, range-A, range-B", indA, indB, lenA-1, lenB-1]);
		show_error("Can't swap, index is out of PLAYER_BAG bounds", 0);
		return;
	}
	
	/// swap items
	var itemA = bag_objA.items[indA];
	var amountA = bag_objA.amount[indA];
	bag_objA.items[indA] = bag_objB.items[indB];
	bag_objA.amount[indA] = bag_objB.amount[indB];
	bag_objB.items[indB] = itemA;
	bag_objB.amount[indB] = amountA;
}
