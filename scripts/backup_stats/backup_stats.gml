// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function backup_stats(){
	STAT_DATA.life = obj_player.life.export();
	STAT_DATA.damage = obj_player.damage.export();
	STAT_DATA.spd = obj_player.spd.export();
	STAT_DATA.stamina = obj_player.stamina.export();
}
