/// @description setup

draw_self();

if(has_key){
	var offset = scr_wave(-12, -4, 1, 0);
	var sprite = key_to_unlock.sprite;
	var index = key_to_unlock.index;
	draw_sprite_ext(sprite, index, x, bbox_top + offset, 1, 1, 45, c_white, 0.5);
}



