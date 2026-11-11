/// @description update

var player = instance_nearest(x,y,obj_player);

state = 0;
scr_set_depth();
if(scr_check_instance(player)){
	if(player.heldItem == id){
		state = 1;
	}
}

switch(state){
	case 0:	/// default
		timer = room_speed;
		zAxis.z_freeze = 0;
		zAxis.update();

		if(scr_check_instance(player)){
			
			// only hold 1 item at a time;
			if(player.hiddenItem == noone){
				in_range = point_in_circle(x,y,player.x, player.y,sprite_width * 1.25);
				if(keyboard_check_pressed(KEY_EQUIP) && zAxis.onGround() && in_range){
					player.hiddenItem = player.heldItem;
					player.heldItem = id;
				}
			}
		} else {
			in_range = false;	
		}
	break;
	case 1:
	
		held_angle = point_direction(x,y,mouse_x,mouse_y);
		var xx = player.x;
		var yy = player.y;
		var zz = 12;
		var xto = lengthdir_x(4, held_angle);
		var yto = lengthdir_y(4, held_angle);
		
		zAxis.z_freeze = 1;
		
		if(timer > 0) timer--;
		
		if(timer <= 0){
			x = xx;
			y = yy;
			zAxis.z = zz;
		} else {
			x = lerp(x, xx, 0.5);	
			y = lerp(y, yy, 0.5);	
			zAxis.z = lerp(zAxis.z, zz, 0.5);	
		}
		
		if(scr_check_instance(player.hiddenItem)){
			player.hiddenItem.cooldown = 30;
			player.hiddenItem.visible = 0;
			player.hiddenItem.x = player.x;
			player.hiddenItem.y = player.y;
		}
		if(mouse_check_button_pressed(mb_left)){
			if(scr_check_instance(player.hiddenItem)){
				player.hiddenItem.visible = 1;
				player.heldItem = player.hiddenItem;
				player.hiddenItem = noone;
			} else {
				player.heldItem = noone;	
			}
			if(player.key_vector.length() > 0){
				 hspeed = player.key_vector.x + xto;
				 vspeed = player.key_vector.y + yto;
				 zAxis.jump(4);
			} else {
				var dx = lengthdir_x(1, held_angle);
				var dy = lengthdir_y(1, held_angle);
				while(place_meeting(x,y,player)){
					x += dx;
					y += dy;
				}
			}
		}
	break;

}

if(zAxis.onGround()){
	friction = 1;	
} else {
	friction = 0;	
}


