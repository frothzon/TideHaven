/// @description setup_partsys();
function setup_partsys() {
	/*
	Created by: Rayu Johnson
	This function creates a new particle system
	*/

	#macro PARTICLE_ENGINE obj_part_system

	globalvar _SYS_TOP, _SYS_BOT, _partArray;
	_SYS_TOP = part_system_create();
	_SYS_BOT = part_system_create();
	_partArray = [];

	/*******************************************/
	part_system_depth( _SYS_TOP, -3000);
	part_system_depth( _SYS_BOT, 1);


	/*
	initiliaze particle properties
	*/

	pSmack = setup_animate(spr_whack,20);
	pDeath = setup_explode(pt_dust);
	pHit = setup_splatter(pt_flare);
	pMisc = setup_wander(pt_orb);
	pSplash = setup_water_ripple(pt_splash);
	/// ice attack
	pFrost = setup_splash(pt_ice);
	pIce = setup_crystal(pFrost,pt_ice);
	/// fire attack
	pFlame = create_small_flame();
	/// rock attack
	pPebble = setup_splatter(pt_earth);
	pRock = setup_rock(pPebble,pt_earth);
	/// Water Attack
	pDrop = setup_splash(pt_water);
	pWater = setup_emit_jump(pDrop,c_aqua);
	/// Wind Attack
	pDust = setup_explode(pt_wind2);
	pWind = setup_wind(pDust,pt_wind);
	/// wood blast
	pWood = setup_splatter(pt_wood);
	/// Rock blast
	pRock = setup_splatter(pt_rock);
	/// claw
	pClaw = setup_claw(pt_claw);

	/***************    EXPLOSIOMS    *************************/
	pFireball = setup_blowup(pt_fireball,30,30,.6,.8,-.001,false);
	pEmber = setup_blowup(pt_firespot,15,20,.5,1,-.01,true);
	pAsh = setup_blowup(pt_ash,15,15,.25,.5,-.01,true);

	//----------------------- Link Particles
	part_type_step(pFireball,3,pEmber);
	part_type_death(pEmber,1,pAsh);
	part_type_blend(pAsh,false);
	/************************************************************/



}
