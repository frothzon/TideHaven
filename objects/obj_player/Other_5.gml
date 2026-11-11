/// @description keep stats backed up

backup_stats();
if(CURRENT_AREA == AREA_OVERWORLD) scr_roomEndSaveState();
scr_save_game();
