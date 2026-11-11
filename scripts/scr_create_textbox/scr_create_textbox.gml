// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_create_textbox(_bgimage = spr_textbox, _fnt = fnt_hud_small){

	globalvar oText;
	oText = {
		textSpeed: 30,	/// letters per second
		x1: 0,
		y1: 100,
		x2: 500,
		y2: 300,
		x1Target: 0,
		x2Target: 500,
		lerpProgress: 0,
		textProgress: 0,
		message: [],
		response: [],
		action: [],
		selection: 0,
		background_index: 0,
		background: _bgimage,
		font: _fnt,
		text_color: c_white,
		timer: 0,
		visible: false,
		resize: function(xx, yy, w, h){
			x1 = xx;
			y1 = yy;
			x2 = xx + w;
			y2 = yy + h;
			x1Target = x1;
			x2Target = x2;
		},
		get_width: function(){
			return x2-x1;
		},
		get_height: function(){
			return y2-y1;
		},
		//------------ Update Textbox -----------//
		step: function(){
			var message_count = array_length(message);
			
			/// disable message box if no text available to show
			visible = true;
			if(message_count <= 0){
				visible = false;
				return;
			}
			
			/// update text message variables
			var text = message[0];
			var _messageLength = string_length(text);
			var _optionCount = array_length(response[0]);
			var _action = action[0];
			
			lerpProgress += (1-lerpProgress)/50;
			textProgress = min(textProgress+textSpeed/room_speed,_messageLength);
			
			/// expand textbox to full size
			x1 = lerp(x1, x1Target, lerpProgress);
			x2 = lerp(x2, x2Target, lerpProgress);
			
			if(textProgress >= _messageLength){
				if(timer < 30) timer++;	
			} else {
				timer = 0;	
			}
			
			/// update text message
			if(keyboard_check_pressed(KEY_EQUIP) || mouse_check_button_pressed(mb_left)){
				if(timer >= 30){
					textProgress = 0;
					/// remove first index from array -> moves to next message
					array_delete(message, 0, 1);
					array_delete(response, 0, 1);
					array_delete(action, 0, 1);
					
					/// run selected action
					if(_action != -1){
						_action(selection);
						/// reset selection
						selection = 0;
					} else {
						show_error("Action not a script",false);
					}
					
					
				} else {
					/// skip to end of current message
					if(textProgress > 2){
						textProgress = _messageLength;	
					}
				}
			}
			/// swap options
			var _shiftIndex = keyboard_check_pressed(KEY_DOWN) - keyboard_check_pressed(KEY_UP);
			selection = clamp(selection+_shiftIndex,0,_optionCount-1);
		},
		/// Draw the textbox
		draw: function(){
			/// exit when not visible
			if(!visible) return;
			if(array_length(message) < 1) return;
			
			/// get temporary variables
			var _print = string_copy(message[0], 1, round(textProgress));
			var _responseList = response[0];
			var _inset = 16;
			var _width = x2-x1-_inset*2;
			var _yOpts = y1 + string_height_ext(_print,-1,_width);
			var _xpos = x1 + _inset;
			var _messageLength = string_length(message[0]);
			
			/// draw background
			draw_sprite_stretched(background, background_index, x1, y1, get_width(), get_height());
			
			/// setup for drawing text
			scr_drawSetText(font, c_black, fa_left, fa_top);
			
			/// draw string inside textbox
			scr_draw_text_outline_ext(_xpos, y1+8, _print, c_black, text_color, _width);
			
			/// set font for buttons
			scr_drawSetText(font, c_black, fa_center, fa_top);
			_xpos = (x1+x2) * 0.5;
			
			/// draw options for response -> selection
			if(textProgress >= _messageLength){
				var _responseCount = floor(array_length(_responseList));
				var _ready = timer / 30;
				draw_set_alpha(_ready);
				_yOpts = y2 - (string_height("H")+1) * (_responseCount+1);
				for(var i = 0; i < _responseCount; i++){
					var _text = _responseList[i];
					_yOpts += string_height("H")+1;
					
					/// change selection text
					var is_selected = i == selection && _ready;
					if(is_selected) _text = "[" + string(_text) + "]";
					var color_select = is_selected? c_lime : c_white;
					
					/// draw options
					scr_draw_text_outline(_xpos, _yOpts, _text,c_black,color_select);
					
				}
				draw_set_alpha(1);
			}
		}
	};
}

/// Update textbox
function scr_updateTextBox(){
	oText.step();
}

/// Draw textbox
function scr_drawTextBox(){
	oText.draw();
}

/// default response for message
function defaultResponse(index){
	show_debug_message(index);
}

/// Create textbox message -- automatically queued for you!
/// text -> string											-- "hello world"
/// bg_index -> background index for textbox				-- 0,1,2.. etc
/// responses -> array of response strings					-- ["resp1","resp2",....,"respN"]
/// func -> function to run, passes in response index		-- function myFunc(index){...}
function scr_showMessage(text, bg_index, responses, func = defaultResponse){
	array_push(oText.message, text);
	if(bg_index > -1){
		oText.background_index	= bg_index;
	}
	
	if(!is_array(responses) || array_length(responses) < 1){
		array_push(oText.response, ["Ok"]);
		array_push(oText.action, defaultResponse);
	} else {
		array_push(oText.response, responses);
		array_push(oText.action, func);
	}
}

function scr_runFunctionArray(fcn, array){
	switch(array_length(array)){
		case 1: fcn(array[0]); break;
		case 2: fcn(array[0],array[1]); break;
		case 3: fcn(array[0],array[1],array[2]); break;
		case 4: fcn(array[0],array[1],array[2],array[3]); break;
		case 5: fcn(array[0],array[1],array[2],array[3],array[4]); break;
		case 6: fcn(array[0],array[1],array[2],array[3],array[4],array[5]); break;
		case 7: fcn(array[0],array[1],array[2],array[3],array[4],array[5],array[6]); break;
		case 8: fcn(array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7]); break;
		default: show_error("Array too large....",true); break;
	}
}

function scr_drawSetText(font, text_color, halign, valign){
	draw_set_font(font);
	draw_set_halign(halign);
	draw_set_valign(valign);
	draw_set_color(text_color);
}