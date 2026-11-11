// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_use_recipe(item, bag){
	/*
	data = {
		items: _itemList, 
		amount: _qtyList,
		drop: _dropItem
	};
	*/
	/// check if it can be made
	var items = item.data.items;
	var amount = item.data.amount;
	var drop = item.data.drop;
	
	/// if items/quantities are not present, we are not ready
	for(var i = 0; i < array_length(items); i++){
		var find = scr_bag_search(bag, items[i]);
		if(find < 0){
			ready = 0;
			return;
		} else {
			var qty = scr_bag_get_amount(bag, find);
			if(qty < amount[i]){
				ready = 0;
				return;
			}
		}
	}
	
	/// remove ingredients
	for(var i = 0; i < array_length(items); i++){
		scr_bag_add_item(bag, items[i], -amount[i]);
	}
	/// add item
	scr_bag_add_item(bag, drop, 1);
	
	/// play sound
	scr_play_sound(snd_craft, 0);
}