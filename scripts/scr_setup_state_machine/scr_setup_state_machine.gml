// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/*
	incredibly simple switch based state machine
	
	implement like this:
	
	switch(scr_get_state_index()){
		case 0:
			/// run code for state 0
			if(scr_state_startup()){
				/// initialization code (only runs on state start)
			}
			if(condition){
				/// go to second state
				scr_switch_state(1);
			}
		break;
		case 1:
			/// run code for state 1
			
			/// if state runs for 3 seconds, do this
			if(scr_get_state_time() > 3){
				/// go to first state
				scr_switch_state(0);
			}
		break;
	}
	scr_update_state_timer();
	
*/
function scr_setup_state_machine(){
	_SM_ = {
		state: 0,
		state_timer: 0
	}
}

function scr_switch_state(ind){
	_SM_.state_timer = -1;
	_SM_.state = ind;
}

function scr_update_state_timer(){
	_SM_.state_timer ++;
}

function scr_get_state_index(){
	return(_SM_.state);	
}

function scr_get_state_time(){
	return(_SM_.state_timer/room_speed);	
}

function scr_state_startup(){
	return(_SM_.state_timer == 0);
}