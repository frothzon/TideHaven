// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_check_recipe(item, bag=PLAYER_BAG_ITEMS){
	/*
	data = {
		items: _itemList, 
		amount: _qtyList,
		drop: _dropItem
	};
	*/
	/// check if it can be made
	var items = item.data.items;
	var item_counter = [];
	
	/// if items/quantities are not present, we are not ready
	for(var i = 0; i < array_length(items); i++){
		var find = scr_bag_search(bag, items[i]);
		item_counter[i] = 0;
		if(find < 0){
			item_counter[i] = 0;
		} else {
			var qty = scr_bag_get_amount(bag, find);
			item_counter[i] = qty;
		}
	}
	
	return item_counter;
}