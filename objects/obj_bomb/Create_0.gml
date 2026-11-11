/// @description setup bomb


// Inherit the parent event
event_inherited();


blowup_timer = room_speed * 4;
fuse_pos = [x,y];
sound_playing = -1;
damage_matrix = scr_setup_dmg_matrix(1,1,1);
range = 32;
damage = 10;
scr_bag_add_item(PLAYER_BAG_TOOLS, TOOL_BOMB, -1);