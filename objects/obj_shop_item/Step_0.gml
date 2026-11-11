/// @description check range

///in_range = point_in_circle(obj_player.x, obj_player.y, x, y, 24);
/*
select_quantity = false;
buy_quantity = 1;
*/
 
switch(state){
	case 0:
	buy_timer--;
	if(keyboard_check_pressed(KEY_EQUIP) && !GAME_PAUSED && in_range && buy_timer <= 0){
		if(quantity == 0){
			scr_showMessage("Sold Out!", 0, ["ok"]);
		} else {
			/// attempt to buy
			var txt = "Buy a " + string(item.name) + "?";
			buy_timer = room_speed;
			scr_showMessage(txt, 0, ["Yes", "No"], function(ind){
				if(ind == 1){
					scr_showMessage("See you later!", 0, ["ok"]);	
				} else {
					buy_timer = room_speed;
					state = 1;	
					obj_textbox.force_pause = true;
					BUY_AMOUNT = 1;
				}
			});
		}
	} 
	break;
	case 1:
	
		if(quantity == 0){
			state = 0;
			select_quantity = false;
		} else {
			select_quantity = true;
		
			var bag = item.type == ITEM_TYPE.tool ? PLAYER_BAG_TOOLS : PLAYER_BAG_ITEMS;
			var find = scr_bag_search(bag, item);
		
			buy_max = quantity < 0 ? 99 : quantity;
		
			if(find > -1){
				var qty = bag.amount[find];
				if(qty >= item.limit && item.limit > -1){
					buy_max = max(0,item.limit-bag.amount[find]);	
				}
			}
		
			buy_price = buy_quantity * cost;
					
			if(buy_timer <= 0){
				if(keyboard_check_pressed(KEY_EQUIP) || mouse_check_button_pressed(mb_left)){
					state = 2;	
					obj_textbox.force_pause = false;
					select_quantity = false;
				}
			} else {
				buy_timer--;	
			}
		}
		
	break;
	case 2:
		buy();
	break;
}

finish = function(ind){
	buy_timer = room_speed;
}
buy = function(){
	if(MONEY >= buy_price){
					
		var bag = item.type == ITEM_TYPE.tool ? PLAYER_BAG_TOOLS : PLAYER_BAG_ITEMS;
		var find = scr_bag_search(bag, item);
		buy_price = buy_quantity * cost;
					
		if(find > -1){
			var qty = bag.amount[find] + buy_quantity;
			if(qty >= item.limit && item.limit > -1){
				scr_showMessage("You are maxed out on this item!", 0, ["ok"]);
				state = 0;
				finish(0);
				return;
			}
		}
					
		if(bag == PLAYER_BAG_TOOLS){
			scr_play_sound(OGG_Heroic_Win_Sting, 0);	
		} else {
			scr_play_sound(snd_collect, 0);	
		}
					
		MONEY -= buy_price;
		scr_bag_add_item(bag, item, buy_quantity);
		scr_showMessage("You bought a " + item.name + "!", 0, ["ok"], finish);
		if(buy_quantity >= 1) {
			quantity -= buy_quantity;
			show_debug_message(buy_quantity);
		} else if(quantity == 0){
			scr_showMessage("All sold out now!", 0, ["ok"], finish);
		}
		state = 0;
	} else {
		scr_showMessage("You need more money!", 0, ["ok"], finish);
		state = 0;
	}
}

