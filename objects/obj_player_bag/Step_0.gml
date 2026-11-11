/// @description update gui

// mouse release in HTML5 broken, timer keeps item use trigger from being continuous
if(use_item_timer > 0) use_item_timer--;

if(GAME_PAUSED || MENU_VIEW == MENU_VIEW_MAP || MENU_VIEW == MENU_VIEW_SKILLS) exit;

/// update the Bag Gui
scr_step_bag_gui();

/// testing the PLAYER_GEAR
scr_update_test_gear();

/// update drag and drop system
scr_update_dragger(PLAYER_BAG_CURRENT, PLAYER_GEAR);

/// tabs
BAG_TAB_SLOTS.update();
