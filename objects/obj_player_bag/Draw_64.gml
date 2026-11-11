/// @description draw bags

if(GAME_PAUSED || MENU_VIEW == MENU_VIEW_MAP || MENU_VIEW == MENU_VIEW_SKILLS) exit;


/// draw tabs
scr_draw_tab_gui();

/// draw PLAYER_BAG in gui layer
switch(bag_index){
	case BAG.items:
	case BAG.recipes:
	scr_draw_bag_gui(PLAYER_BAG_CURRENT);
	break;
}

/// draw PLAYER_GEAR in gui layer
scr_draw_gear_gui(PLAYER_GEAR, PLAYER_BAG_ITEMS);

/// draw item being dragged
scr_draw_dragger();

/// Draw PAUSED text in GUI layer
if(MENU_VIEW == MENU_VIEW_INVENTORY){
	draw_set_font(fnt_hud_big);
	draw_set_halign(fa_middle);
	draw_text_transformed_color(
		display_get_gui_width()*0.5, 34, "INVENTORY", 4, 4, scr_wave(-15, 15, 2, 0), c_black,c_black,c_black,c_black,1
	);
	draw_text_transformed_color(
		display_get_gui_width()*0.5, 32, "INVENTORY", 4, 4, scr_wave(-15, 15, 2, 0), c_yellow,c_yellow,c_orange,c_orange,1
	);
	scr_draw_reset();
}

/// test gui position
/*
var pos = CAMERA.mouse_gui();
draw_text(pos[0], pos[1], pos);
*/