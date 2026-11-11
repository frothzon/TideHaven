
#macro SURFACE_SIZE 128

/// @description  draw_8d_creature()
function CSJ_render_8d_creature() {
	/************************************
	Set the sprites of the creature
	*************************************/
	var creature_sprites = [];
	var spr_surf;
	var anim_index;
	var stage = 0;
	
	while(stage < 2){
		switch(stage){
		    case 0: spr_surf = surface_create(SURFACE_SIZE,SURFACE_SIZE);
				//show_debug_message(SURFACE_SIZE);
		        stage = 1;
		        break;
		    case 1:
		        for(var i = 0; i < 8; i++){
		            image_angle = i*45;
		            for(anim_index = 0; anim_index < 60; anim_index+=4){
		                surface_set_target(spr_surf);
		                draw_clear_alpha(c_black,0);
		                ///draw_creature_shadow();
		                CSJ_draw_creature(anim_index);
		                surface_reset_target();
		                if(anim_index == 0){
		                    creature_sprites[i] = sprite_create_from_surface(spr_surf, 1, 1, SURFACE_SIZE-1, SURFACE_SIZE-1, 0, 0, SURFACE_SIZE*.5, SURFACE_SIZE*.5);
							sprite_set_speed(creature_sprites[i], 5, spritespeed_framespersecond);
		                } else {
		                    sprite_add_from_surface(creature_sprites[i], spr_surf, 1, 1, SURFACE_SIZE-1, SURFACE_SIZE-1, 0, 0);
		                }
		            }
		        }
		        surface_free(spr_surf);
		        creature_sprites[8] = creature_sprites[0];
		        /// get texels for shader
		        shd_set_texel(creature_sprites[0],2);
		        stage = 2;
		        break;
		}
	}
	return creature_sprites;

}


/// @description  dra_long_body(i, anim_index)
/// @param i
function CSJ_draw_long_body(i, anim_index = 0) {


	var ob = parts[i],
	        xoff = (SURFACE_SIZE*0.5) + lengthdir_x(ob[1],image_angle),
	        yoff = (SURFACE_SIZE*0.5) + lengthdir_y(ob[1],image_angle),
	        set_index = anim_index>>1;
	    if(ob[4] != -1){
	        set_index = ob[4];
	    }

	switch(ob[0]){
	        case TYPE.LEG:
	            var mirror = power(-1,i);
	            CSJ_draw_feet(ob[1],ob[2]*mirror,ob[3], anim_index);
	            draw_sprite_ext(sprite_catch[ob[0]],set_index,xoff,yoff-ob[5],ob[2]*mirror,ob[3],image_angle,leg_color,1);
	            draw_sprite_ext(sprite_catch[ob[0]],29-set_index,xoff,yoff-ob[5],ob[2]*mirror,-ob[3],image_angle,leg_color,1);
	        break;
	        case TYPE.EYES:
	            var xoff2 = lengthdir_x(4*scale,image_angle),
	                yoff2 = lengthdir_y(4*scale,image_angle); 
	            draw_sprite_ext(sprite_catch[ob[0]],set_index,xoff+xoff2,yoff-ob[5]+yoff2,ob[2],ob[3],image_angle,c_white,1);
	        break;
	        default:
	            draw_sprite_ext(sprite_catch[ob[0]],set_index,xoff,yoff-ob[5],ob[2],ob[3],image_angle,body_color,1);
	            ///draw_sprite_textured(sprite_catch[ob[0]],set_index,body_texture,xoff,yoff-ob[5],ob[2],ob[3],image_angle,body_color,1,i);
	        break;
	    }



}


/// @description  dra_long_body(i, anim_index)
/// @param i
function CSJ_draw_tall_body(i, anim_index = 0) {

	var ob = parts[i],
	        xoff = (SURFACE_SIZE*0.5) + lengthdir_x(ob[1],image_angle),
	        yoff = (SURFACE_SIZE*0.5) + lengthdir_y(ob[1],image_angle),
	        set_index = anim_index>>1;
	    if(ob[4] != -1){
	        set_index = ob[4];
	    }
    
	switch(ob[0]){
	        case TYPE.LEG:
				var mirror = power(-1,i);
				CSJ_draw_feet(ob[1],ob[2]*mirror,ob[3], anim_index);
	            draw_sprite_ext(sprite_catch[ob[0]],set_index,xoff,yoff-ob[5],ob[2],ob[3],image_angle,leg_color,1);
	        break;
	        case TYPE.EYES:
	            draw_sprite_ext(sprite_catch[ob[0]],set_index,xoff,yoff-ob[5],ob[2],ob[3],image_angle,c_white,1);
	        break;
	        case TYPE.BODY:
	            draw_sprite_ext(sprite_catch[ob[0]],set_index,xoff,yoff-ob[5],ob[2],ob[3],0,body_color,1);
	            ///draw_sprite_textured(sprite_catch[ob[0]],set_index,body_texture,xoff,yoff-ob[5],ob[2],ob[3],image_angle,body_color,1,i);
	        break;
	        default:
	            draw_sprite_ext(sprite_catch[ob[0]],set_index,xoff,yoff-ob[5],ob[2],ob[3],image_angle,body_color,1);
	        break;
	    }



}

/// @description  CSJ_ini_long_body
function CSJ_ini_long_body() {

	/**************************** Long-ways creature body *********************/
	/// data = array(0-type, 1-position, 2-xscale, 3-yscale, 4-index, 5-z)
	/// make legs

	scale = random_range(.25,.6);
	surf_size = floor(SURFACE_SIZE*scale + 8);

	sprite_catch = [
	    spr_ball,
	    leg_type,
	    spr_body,
	    spr_head,
	    spr_eyes,
	    leg_type
	];

	part_count = irandom_range(1,3);
	part_number = 0;
	var offset = part_count*12;
	for (var i=0; i<part_count; i+=1)
	{
	    ///parts[part_number++] = array(TYPE.FOOT,i*16-offset,1,1,-1,0);
	    parts[part_number++] = [TYPE.LEG,(i*16-offset)*scale,scale,scale,-1,0];
	};
	var random_head = irandom(sprite_get_number(spr_head)-1);
	var random_body = irandom(sprite_get_number(spr_body)-1);
	var random_eye = irandom(sprite_get_number(spr_eyes)-1);
	parts[part_number++] = [TYPE.BODY, (-offset*.5)*scale, ((part_count*.25)+.6)*scale, scale,random_body, 4];
	parts[part_number++] = [TYPE.HEAD, (part_count*4+2)*scale, scale, scale, random_head, 8];
	parts[part_number++] = [TYPE.EYES, (part_count*4)*scale, scale, scale, random_eye, 12];

	/// return to disorder
	randomize();



}


/// @description  CSJ_ini_long_body
function CSJ_ini_tall_body() {

	/**************************** Long-ways creature body *********************/
	/// data = array(0-type, 1-position, 2-xscale, 3-yscale, 4-index, 5-z)
	/// make legs
	part_number = 0;
	scale = random_range(.25,0.8);
	surf_size = floor(SURFACE_SIZE*scale);

	leg_sprite = choose(
	    spr_leg1,
	    spr_leg2,
	    spr_leg3,
	    spr_leg4,
	    spr_leg5,
	    spr_leg6
	);

	show_arm = choose(true,false);

	/************* Setup Arms ***********/
	arm_sprite = -1;
	if(show_arm){

	    if(leg_sprite == spr_leg6){
	        arm_sprite = spr_arm08;
	    } else {
	        arm_sprite = choose(
	            spr_arm01,
	            spr_arm02,
	            spr_arm03,
	            spr_arm04,
	            spr_arm05,
	            spr_arm06,
	            spr_arm07
	        );
	    }
	}

	sprite_catch = [
	    spr_ball,
	    leg_sprite,
	    spr_ball,
	    spr_head,
	    spr_eyes,
	    arm_sprite
	];

	var random_head = irandom(sprite_get_number(spr_head)-1);
	var random_body = irandom(sprite_get_number(spr_body)-1);
	var random_eye = irandom(sprite_get_number(spr_eyes)-1);
	var body_scale = random_range(.25,1);

	parts[part_number++] = [TYPE.LEG, 8*scale, scale*body_scale, scale*body_scale,-1, 2*scale];
	parts[part_number++] = [TYPE.BODY, 0, scale*body_scale, scale*body_scale,random_body, 8*scale];
	if(show_arm){
	    parts[part_number++] = [TYPE.ARM, scale, scale, scale,-1, 11*scale];
	}
	parts[part_number++] = [TYPE.HEAD, 0, scale, scale, random_head, 14*scale];
	parts[part_number++] = [TYPE.EYES, 0, scale, scale, random_eye, 20*scale];

	/// return to disorder
	randomize();



}




/// @description  CSJ_draw_shd_outline()
function CSJ_draw_shd_outline() {
	/*******************************
	Draws the image using the outline
	shader
	*******************************/

	shader_set(shd_outline);
	/// set variables to texel size
	shader_set_uniform_f(upixelW,texelW);
	shader_set_uniform_f(upixelH,texelH);
	/// draw sprite
	draw_self();
	shader_reset();



}


/// @description  CSJ_ini_shd_outline();
function CSJ_ini_shd_outline() {
	upixelH = shader_get_uniform(shd_outline,"pixelH");
	upixelW = shader_get_uniform(shd_outline,"pixelW");
	texelW = 0;
	texelH = 0;
}

/// @description  shd_set_texel(sprite, width);
/// @param sprite
/// @param width
function shd_set_texel(argument0, argument1) {
	texelH = argument1*texture_get_texel_height(sprite_get_texture(argument0,0));
	texelW = argument1*texture_get_texel_width(sprite_get_texture(argument0,0));

}

/// @description  CSJ_draw_creature
function CSJ_draw_creature(anim_index) {

	for (var i=0; i<array_length(parts); i+=1){
	    /// draw creature body
	    if(creature_type == 0){
	        CSJ_draw_long_body(i, anim_index);
	    } else {
	        CSJ_draw_tall_body(i, anim_index);
	    }
	};

}

/// @description  CSJ_draw_creature_sprite
function CSJ_draw_creature_sprite() {
	/************************************
	Set the sprites of the creature
	*************************************/

	switch(stage){
	    case 0: spr_surf = surface_create(surf_size,surf_size);
	        stage = 1;
	        break;
	    case 1:
	        /// anim_index
	        for(anim_index = 0; anim_index < 60; anim_index++){
	            surface_set_target(spr_surf);
	            draw_clear_alpha(c_blue,0);
	            ///draw_creature_shadow();
	            CSJ_draw_creature(anim_index);
	            surface_reset_target();
	            if(anim_index == 0){
	                spr_self = sprite_create_from_surface(spr_surf, 0, 0, surf_size, surf_size, true, false, surf_size*.5, surf_size*.5);
	            } else {
	                sprite_add_from_surface(spr_self, spr_surf, 0, 0, surf_size, surf_size, true, false);
	            }
	        }
	        surface_free(spr_surf);
	        stage = 2;
	        /// get texel for shader
	        shd_set_texel(spr_self,1);
	        break;
	    case 2: 
	        sprite_index = spr_self;
	        image_speed = 0;
	        image_angle = 0;
	        stage = 3;
	        break;
	    case 3:
	        ///draw_self();
	        break;
	}



}


/// @description  CSJ_ini_creature(seed);
/// @param seed
function CSJ_ini_creature(argument0) {

	/// set sprites
	spr_self = -1;
	spr_surf = -1;
	stage = 0;
	surf_size = SURFACE_SIZE;
	depth = -1000;

	/// make creatures
	var val = is_real(argument0) ? argument0 : 0;
	random_set_seed(val);

	creature_type = 1;    /// only picking tall bodies for now

	leg_type = choose(
	    spr_app1,
	    spr_app2,
	    spr_app3,
	    spr_app4,
	    spr_app5,
	    spr_app6,
	    spr_app7,
	    spr_app8,
	    spr_app9,
	    spr_app10,
	    spr_app11,
	    spr_app12,
	    spr_app13,
	    spr_app14,
	    spr_app15,
	    spr_app16,
	);

	enum TYPE{
	    FOOT,
	    LEG,
	    BODY,
	    HEAD,
	    EYES,
	    ARM
	}

	var hue = irandom(255);
	body_color = make_colour_hsv(hue,255,255);
	leg_color = merge_colour(body_color,c_black,.15);

	///body_texture = irandom(sprite_get_number(spr_texture)-1);

	/**************************** Long-ways creature body *********************/
	/// data = array(0-type, 1-position, 2-xscale, 3-yscale, 4-index, 5-z)
	/// make legs

	//body_surface = [-1,-1,-1,-1,-1,-1,-1,-1];
	foot_index = irandom(sprite_get_number(spr_feet));

	if(creature_type == 0){
	    CSJ_ini_long_body();
	} else {
	    CSJ_ini_tall_body();
	}

}

/// @description  CSJ_name_generator(seed)
/// @param seed
function CSJ_name_generator(argument0) {
	/***************************
	This returns a string of
	characters
	****************************/
	var val = is_real(argument0) ? argument0 : 0;
	random_set_seed(val);

	var vowel = ["a","e","i","o","u","y"];
	var cons1 = ["b","c","d","f","g","h"];
	var cons2 = ["j","k","l","m","n","p","r","t","w","x"];
	var cons3 = ["ph","ch","gr","br","cr","dr","fr","pr","th"];
	var end1 = ["un","on","an","chu","cha","ard","ite","aur","awr"];

	var length = irandom_range(2,6);
	var get_name = "";
	var start = choose(0,1);

	for(var i = start; i < length+start; i++){
	    if(i%2 == 0){
	        var picker = choose(cons1,cons2,cons3);
	        get_name += picker[irandom(array_length(picker)-1)];
	    } else {
	        get_name += vowel[irandom(array_length(vowel)-1)];
	    }
	}

	var caps = string_upper(string_copy(get_name,1,1));
	var new_name = caps + string_copy(get_name,2,string_length(get_name)-1);
	new_name += end1[irandom(array_length(end1)-1)];

	return(new_name);



}



/// @description  CSJ_draw_feet(leg-xoff, scale-x, scale-y, anim_index);
/// @param leg-xoff
/// @param  scale-x
/// @param  scale-y
/// @param anim_index
function CSJ_draw_feet(argument0, argument1, argument2, argument3) {

	///show_debug_message(anim_index>>1);

	var sx = argument1,
	    sy = argument2,
	    top_foot = CSJ_foot_points_app(argument3>>1),
	    bot_foot = CSJ_foot_points_app(29-(argument3>>1)),
	    dis1 = point_distance(0,0,top_foot[0]*sx,top_foot[1]*sy),
	    dis2 = point_distance(0,0,bot_foot[0]*sx,-bot_foot[1]*sy*.9),
	    dir1 = point_direction(0,0,top_foot[0]*sx,top_foot[1]*sy),
	    dir2 = point_direction(0,0,bot_foot[0]*sx,-bot_foot[1]*sy*.9),
	    x1 = x + lengthdir_x(argument0,image_angle) + lengthdir_x(dis1,dir1+image_angle),
	    y1 = y + lengthdir_y(argument0,image_angle) + lengthdir_y(dis1,dir1+image_angle),
	    x2 = x + lengthdir_x(argument0,image_angle) + lengthdir_x(dis2,dir2+image_angle),
	    y2 = y + lengthdir_y(argument0,image_angle) + lengthdir_y(dis2,dir2+image_angle);
    
    
	draw_sprite_ext(spr_feet,foot_index,x1,y1,abs(sx),sy,image_angle,body_color,1);
	draw_sprite_ext(spr_feet,foot_index,x2,y2,abs(sx),sy,image_angle,body_color,1);



}

/// @description  CSJ_foot_points_app(index)
/// @param index
function CSJ_foot_points_app(argument0) {
	/*******************************************************
	Return the position of the foot as part of the animation
	*******************************************************/

	var foot_pos,
	    i = argument0;

	foot_pos[0] = [24,4];
	foot_pos[1] = [30,4];
	foot_pos[2] = [33,6];
	foot_pos[3] = [38,10]; ///
	foot_pos[4] = [42,12];
	foot_pos[5] = [45,18];
	foot_pos[6] = [45,23];
	foot_pos[7] = [45,27];
	foot_pos[8] = [45,28];
	foot_pos[9] = [45,24];
	////
	foot_pos[10] = [45,18];
	foot_pos[11] = [43,14];
	foot_pos[12] = [40,10];
	foot_pos[13] = [36,6];
	foot_pos[14] = [31,4];
	foot_pos[15] = [26,3];
	foot_pos[16] = [22,3];
	foot_pos[17] = [17,4];
	foot_pos[18] = [14,5];
	foot_pos[19] = [11,7];
	///
	foot_pos[20] = [8,9];
	foot_pos[21] = [5,12];
	foot_pos[22] = [4,15];
	foot_pos[23] = [3,16];
	foot_pos[24] = [5,13];
	foot_pos[25] = [7,10];
	foot_pos[26] = [9,8];
	foot_pos[27] = [13,7];
	foot_pos[28] = [16,5];
	foot_pos[29] = [20,4];

	var newPos = foot_pos[i],
	    xget = (newPos[0] - 24),
	    yget = (newPos[1] - 33);
    
	return([xget,yget]);
}

function CSJ_draw_self_shadow(){
	var ys = image_yscale;
	var bl = image_blend;
	var al = image_alpha;
	var yy = y;
	y += 4;
	image_yscale *= 0.5;
	image_alpha = 0.5;
	image_blend = c_black;
	draw_self();
	image_yscale = ys;
	image_alpha = al;
	image_blend = bl;
	y = yy;
}


function CSJ_draw_creature_self(sprites, zheight = 0){
	sprite_index = sprites[round(direction/45)];
	image_index += image_speed;
	if(image_index > image_number) image_index -= image_number;
	/// draw shadow
	//var size = sprite_width/32;
	//CSJ_draw_self_shadow();
	var yy = y;
	y -= zheight;
	///draw_self();
	CSJ_draw_shd_outline();	
	y = yy;
}