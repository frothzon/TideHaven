/// @description update fuse

// Inherit the parent event
event_inherited();

/*
var ratio = blowup_timer / (room_speed * 4)
draw_line(x,bbox_top,x,bbox_top - 16 * ratio);

var part = PARTICLE_ENGINE.pFlame;
if(on_fire){
	
	var xx = x + lengthdir_x(17,image_angle+90);
	var yy = y + lengthdir_y(17,image_angle+90);
	burst_particle(part,xx,yy,1,false);
*/

var part = PARTICLE_ENGINE.pFlame;
var ratio = blowup_timer / (room_speed * 4);
fuse_pos = [x, bbox_top - 8*ratio - zAxis.z];
burst_particle(part,fuse_pos[0],fuse_pos[1],1,false);

/// play fire sound
if(!audio_is_playing(sound_playing)){
	sound_playing = scr_play_sound(snd_fuse, 0, fuse_pos);
}

blowup_timer--;
if(blowup_timer <= 0){
	part = PARTICLE_ENGINE.pFireball;
	instance_destroy();
	burst_particle(part, x, (bbox_top+bbox_bottom)*0.5,1,false);
	///
	var hitlist = ds_list_create();
	collision_circle_list(x,y,range,obj_wall,1,1,hitlist,0);

	for(var i = 0; i < ds_list_size(hitlist); i++){
		var hit = hitlist[| i];
		if(variable_instance_exists(hit, "life")){
			with(hit){
				scr_take_damage(-1, other.damage);
			}
		}
	}
	
	if(point_in_circle(x,y,obj_player.x,obj_player.y,range)){
		/// hurt player
		obj_player.life.value -= damage;
		with(obj_player){
			scr_switch_state(STATE.hurt);
		}
	}
}