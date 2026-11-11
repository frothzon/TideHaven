// shortcuts
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// move in direction
/// @desc scr_jump();
/// @param distance
/// @param direction
function scr_jump(g_distance, g_direct){
    x += lengthdir_x(g_distance, g_direct);
    y += lengthdir_y(g_distance, g_direct);
}

/// @desc scr_chance();
/// @param ratio
function scr_chance(fraction){
	return(random(1) <= fraction);	
}

/// @desc scr_concat(text);
/// @param text...
function scr_concat(){
	var _str = "";
	for( var _i = 0; _i < argument_count; _i++ ){
		if(is_string(argument[_i])){
			_str += argument[_i];
		} else {
			_str += string( argument[_i] );
		}
	}
	return _str;	
}

/// @desc scr_roll_dice(quantity, sides);
/// @param quantity
/// @param sides
function scr_roll_dice(qty, sides){
	var g_highest = 0;
    repeat (qty) g_highest = max(g_highest, irandom_range(1,sides));
    return g_highest;	
}

/// @desc scr_draw_clipping_mask(sprite,image,x,y);
/// @param sprite
/// @param image_index
/// @param x
/// @param y
function scr_draw_clipping_mask(spr, img, xto, yto){
	gpu_set_blendmode_ext(bm_zero,bm_src_alpha);
	draw_sprite(spr,img,xto,yto);
	gpu_set_blendmode(bm_normal);
}

/// @desc scr_print();
/// @param text...
function scr_print(){
	var _str = string(current_time) + ": ";
	for( var _i = 0; _i < argument_count; _i++ ) _str += is_string(argument[_i]) ? argument[_i] : string( argument[_i]);
	show_debug_message(_str);	
}

/// @desc scr_debug();
/// @param text...
function scr_debug(){
	var _str = string(current_time) + ": ";
	for( var _i = 0; _i < argument_count; _i++ ) _str += is_string(argument[_i]) ? argument[_i] : string( argument[_i]);
	if(debug_mode) show_debug_message(_str);
}


function scr_random_weighted(w_array){
	/// add up all weights
	var len = array_length(w_array);
	var total = 0;			/// get total value
	var distribution = [];	/// evenly distribute weights along total value
	for(var i = 0; i < len; i++){
		total += w_array[i];
		distribution[i] = total;
	}
	/// pick random amount
	var rand_val = irandom(total);
	/// find nearest value
	for(var i = 0; i < len; i++){
		if(distribution[i] >= rand_val){
			return(i);	
		}
	}
	/// max possible value
	return(len-1);
}

function scr_check_instance(object_id){
	if (!is_undefined(object_id) and object_id >= 0 and instance_exists(object_id)){
		return true;
	} else {
		return false;
	}
}

function scr_show_menu(button_sprite, xdraw, ydraw, xmouse, ymouse, string_array){
	/// show_menu(x,y,strings...)

	var str_h   = [],                       /// The individual height of text
	    str_w   = -1,                       /// The total width of the string
	    output  = -1;                       /// Check if mouse is inside
    
	//------------------------------------- Grab all of the text from arguments
	for (var i=0; i<array_length(string_array); i++){
	    str_h[i] = string_height(string_array[i]);
	    str_w = max(str_w,string_width(string_array[i]));

	};

	//--------------------------------------- LOOP AND DRAW

	for(var b = 0; b < array_length(string_array); b++){
	    var xa,ya,xb,yb;
	    xa = xdraw; xb = xdraw + str_w;
	    ya = ydraw; yb = ydraw + str_h[b]-1;
	    //------------------------------- Get Selection
	    var _enter = point_in_rectangle(xmouse,ymouse,xa,ya,xb,yb);
	    if(_enter){
	        output = b;
	    }
	    //------------------------------- Draw Boxes
	    draw_sprite_stretched(button_sprite,_enter,xa,ya,str_w,str_h[b]);
	    //------------------------------- Draw Text
	    draw_set_colour(c_black);
	    draw_text(xa,ya,string_array[b]);
	    draw_set_colour(c_white);
	    //------------------------------- Increment Y position
	    ydraw += str_h[b];
	};
	
	return(output);
}


function scr_wave(from, to, time, offset){
	// Returns a value that will wave back and forth between [from-to] over [duration] seconds
	// Examples
	//      image_angle = scr_wave(-45,45,1,0)  -> rock back and forth 90 degrees in a second
	//      x = scr_wave(-10,10,0.25,0)         -> move left and right quickly

	// Or here is a fun one! Make an object be all squishy!! ^u^
	//      image_xscale = Wave(0.5, 2.0, 1.0, 0.0)
	//      image_yscale = Wave(2.0, 0.5, 1.0, 0.0)

	var a4 = (to - from) * 0.5;
	return from + a4 + sin((((current_time * 0.001) + time * offset) / time) * (pi*2)) * a4;
}

/// wrap a value around to be within the min and max value
/// @param value
/// @param minimum
/// @param maximum
function scr_wrap(value, minval, maxval){
	var g_range = maxval - minval;
	while(value >= maxval) value -= g_range;
	while(value < minval) value += g_range;
	return value;
}

/// @param x
/// @param y
/// @param string
/// @param c_outline
/// @param c_text
function scr_draw_text_outline(xto, yto, str, c1=c_black, c2=c_white, w_outline=1){
	var font = draw_get_font();
	if(font != -1 && font_get_sdf_enabled(font)){
		/// set effect
		font_enable_effects(font, true, {
		    outlineEnable: true,
		    outlineDistance: w_outline,
		    outlineColour: c1
		});
		
		draw_set_color(c2);
		draw_text(xto,yto,str);
		draw_set_color(c_white);
		
		/// clear effect
		font_enable_effects(font, false, {
		    outlineEnable: true,
		    outlineDistance: w_outline,
		    outlineColour: c1
		});
	} else {
		draw_set_color(c1);
		draw_text(xto+0.71,yto-0.71,str);
		draw_text(xto-0.71,yto-0.71,str);
		draw_text(xto,yto+1,str);
		draw_set_color(c2);
		draw_text(xto,yto,str);
		draw_set_color(c_white);
	}
}

/// @param x
/// @param y
/// @param string
/// @param c_outline
/// @param c_text
/// @param width
function scr_draw_text_outline_width(xto, yto, str, c1=c_black, c2=c_white, width=1000){
	var font = draw_get_font();
	if(font != -1 && font_get_sdf_enabled(font)){
		/// set effect
		font_enable_effects(font, true, {
		    outlineEnable: true,
		    outlineDistance: 1,
		    outlineColour: c1
		});
		
		draw_set_color(c2);
		draw_text_ext(xto,yto,str,-1,width);
		draw_set_color(c_white);
		
		/// clear effect
		font_enable_effects(font, false, {
		    outlineEnable: true,
		    outlineDistance: 1,
		    outlineColour: c1
		});
	} else {
		draw_set_color(c1);
		draw_text_ext(xto+0.71,yto-0.71,str,-1,width);
		draw_text_ext(xto-0.71,yto-0.71,str,-1,width);
		draw_text_ext(xto,yto+1,str,-1,width);
		draw_set_color(c2);
		draw_text_ext(xto,yto,str,-1,width);
		draw_set_color(c_white);
	}
}


/// @param vec2{x y}
/// @param obj_collider
/// @param move_speed
function scr_move_free(vec2, obj_check, spd = 1){
	
	/// only move on x axis if the x-speed is not zero
	if(vec2.x != 0){
		/// move on X Axis while no collisions occur
		if(!place_meeting(x + vec2.x * spd, y, obj_check)){
			x += vec2.x * spd;	
		} else {
			/// move until 1 pixel away from collision
			while(!place_meeting(x + vec2.x, y, obj_check)){
				x += vec2.x;
			}
		}
	}
	
	/// only move on y axis if the y-speed is not zero
	if(vec2.y != 0){
		/// move on Y Axis while no collisions occur
		if(!place_meeting(x, y + vec2.y * spd, obj_check)){
			y += vec2.y * spd;	
		} else {
			/// move until 1 pixel away from collision
			while(!place_meeting(x, y + vec2.y, obj_check)){
				y += vec2.y;
			}
		}
	}
}

/// snap to grid when moving along single axis
function scr_snap_to_grid(vec2, grid_size = 8){
	/// shift along y axis to be aligned on an 8 pixel grid
	if(vec2.x != 0 && vec2.y == 0 && y%8 != 0){
		y = lerp(y, round(y / grid_size)*grid_size, 0.2);
	}
	
	/// shift along x axis to be aligned on an 8 pixel grid
	if(vec2.y != 0 && vec2.x == 0  && x%8 != 0){
		x = lerp(x, round(x / grid_size)*grid_size, 0.2);
	}
}

/// draw healthbar
function scr_draw_bar(bar_sprite, xx, yy, w, h, ratio, c1=c_white, c2=c_white){
	draw_sprite_stretched(bar_sprite, 0, xx, yy, w, h);
	var rr = clamp(ratio, 0, 1);
	var col = merge_color(c1, c2, ratio);
	draw_sprite_stretched_ext(bar_sprite, 1, xx, yy, lerp(0,w,rr), h, col, 1);
}

/// if mouse is in box
function scr_mouse_in_bbox(){
	return(point_in_rectangle(mouse_x,mouse_y,bbox_left,bbox_top,bbox_right,bbox_bottom));	
}

/// reset drawing
function scr_draw_reset(){
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_font(-1);
}

/// shuffle an array
function scr_shuffle_array(arr){
	var len = array_length(arr);
	repeat(len*2){
		/// get random positions
		var ind1 = irandom(len-1);
		var ind2 = irandom(len-1);
		/// make sure they don't match
		while(ind1 == ind2) ind2 = irandom(len-1);
		var save = arr[ind1];
		arr[@ ind1] = arr[ind2];
		arr[@ ind2] = save;
	}
}

/// check if position has any object in the list
function scr_place_meeting_list(xx,yy,obj_list){
	var safe = 0;
	var len = array_length(obj_list);
	for(var i = 0; i < len; i++){
		safe |= collision_circle(xx,yy-8,8,obj_list[i],0,1) >= 0;
		if(!safe) break;
	}
	return(safe);
}

/// move out of collision
function scr_collide_move(){
	var dir = (x == other.x && y == other.y) ? irandom(360) : point_direction(other.x,other.y,x,y);
	var dx = lengthdir_x(1, dir);
	var dy = lengthdir_y(1, dir);
	var stop = sprite_width;
	
	while(place_meeting(x,y,other)){
		//x += dx;
		//y += dy;
		var _tiles = get_wall_tileset();
		move_and_collide(dx, dy, _tiles);
		if(stop-- < 0) break;
	}
}

/// random binary number -> 1, 2, 4, 8
function scr_random_bitShift(arr){
	var _shift = scr_random_weighted(arr);
	var _val = 1 << _shift;
	show_debug_message("4-bit");
	show_debug_message(_shift);
	show_debug_message(_val);
	return(_val);
}

/// random list
function scr_random_list(size, minval, maxval){
	var out = [];
	for(var i = 0; i < size; i++){
		out[i] = irandom_range(minval, maxval);
	}
	return(out);
}

/// @param x
/// @param y
/// @param collision-layer-name
function scr_tile_at_position(dx, dy, layer_name){
	var layer_id = layer_get_id(layer_name);
	var map_id = layer_tilemap_get_id(layer_id);
	
	return(tilemap_get_at_pixel(map_id, dx, dy) > 0);
	
}

/// @param x
/// @param y
/// @param collision-layer-name
function scr_check_collision_advanced(dx, dy, layer_name, obj, reverse){

	var colls = reverse ? scr_tile_at_position(dx, dy, layer_name) <= 0 : scr_tile_at_position(x + dx, y, layer_name) > 0;
	colls |= place_meeting(dx, dy, obj);

	return(colls);
	
}

/// @param vec2{x y}
/// @param obj_collider
/// @param move_speed
function scr_move_free_ext(vec2, obj_check, spd = 1, layerName, reverseTile = 1){
	
	/// only move on x axis if the x-speed is not zero
	if(vec2.x != 0){
		/// move on X Axis while no collisions occur
		if(!scr_check_collision_advanced(x + vec2.x * spd, y, layerName, obj_check, reverseTile)){
			x += vec2.x * spd;	
		} else {
			/// move until 1 pixel away from collision
			while(!scr_check_collision_advanced(x + vec2.x, y, layerName, obj_check, reverseTile)){
				x += vec2.x;
			}
		}
	}
	
	/// only move on y axis if the y-speed is not zero
	if(vec2.y != 0){
		/// move on Y Axis while no collisions occur
		if(!scr_check_collision_advanced(x, y + vec2.y * spd, layerName, obj_check, reverseTile)){
			y += vec2.y * spd;	
		} else {
			/// move until 1 pixel away from collision
			while(!scr_check_collision_advanced(x, y + vec2.y, layerName, obj_check, reverseTile)){
				y += vec2.y;
			}
		}
	}
}

function array_duplicate(arr){
	return(json_parse(json_stringify(arr)));	
}

function string_number_formatted(value, dec=3){
	var val2 = value;
	var ee = 0;
	/// suffix for numbering greater than 999
	var suffix = ["","k","M","B","T","Z"];
	/// suffix index increases every 1000
	while(val2 >= 1000){
		ee++;
		val2 /= 1000;
	}
	var txt = string(val2);
	/// keep only 3 numbers + decimal
	if(ee>0){
		/// if 3th index is decimal, omit decimal
		if(string_length(txt) < dec+1){
			while(string_length(txt) < dec+1) {
				txt += "0";
			}
		} else if(string_char_at(txt, dec+1) == "."){
			txt = string_copy(txt, 1, dec);
		} else {
			txt = string_copy(txt, 1, dec+1);
		}
	}
	var ind = clamp(ee, 0, array_length(suffix)-1);
	/// return string with suffix
	return(txt + string(suffix[ind]));
}

/// @func sct_linestep(from, to, time, offset);
/// @desc loops over and over over a set interval
/// @param {Real} from (start value)
/// @param {Real} to (end value)
/// @param {Real} time (seconds)
/// @param {Real} offset (seconds)
/// @return {Real} value
function sct_linestep(from, to, time, offset){
	var ts = current_time/1000;
	var ratio = ((ts + offset) % time) / time;
	return lerp(from, to, ratio);
}
