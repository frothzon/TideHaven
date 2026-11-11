// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function setup_skills(){
	/// create stat nodes
	var ind = 1;
	skill_nodes = [];
	skill_offset = {x: 0,y: 0,alpha:0};
	for(var i = 0; i < 5; i++){
		var xx = 100 * i;
		var last = -1;
		for(var j = 0; j < 5; j++){
			var yy = 80 * j;
			// Use the inventory slot skin until a dedicated skill-node sprite is available.
			var n1 = new Skill($"Skill {ind}", spr_inv_slot, xx, yy, !(j==0), 0, 5);
			n1.import(SKILL_DATA[ind]);
			if(last != -1){
				last.add_child(n1);	
			}
			last = n1;
			array_push(skill_nodes, n1);
			ind++;
		}
	}
	for(var icon_i = 0; icon_i < 9; icon_i++){
		skill_nodes[icon_i].icon_index = icon_i;
	}
	show_skills = false;
	
	/// set up individual nodes and skills
	if(!is_struct(PLAYER_SKILLS)){
		PLAYER_SKILLS = {
			// column1
			HP: 0,
			shield1: 0,
			shield2: 0,
			regen: 0,
			steal: 0,
			// column2
			speed: 0,
			stamina: 0,
			stmRegen: 0,
			potentcy: 0
		}
	}
	
	//------------------------ HP increasing nodes 0, 1, 2, 3, 4
	var _skillInd = 0;
	
	skill_nodes[_skillInd].name = "HP.1";
	skill_nodes[_skillInd].desc = "Increase HP by 10";
	skill_nodes[_skillInd].full = 10;
	skill_nodes[_skillInd].on_increment = function(node){
		/// increase life
		life.change(10, 1);
		PLAYER_SKILLS.HP = node.points * 10;
	}
	_skillInd++;
	
	skill_nodes[_skillInd].name = "SHLD.1";
	skill_nodes[_skillInd].desc = "Increase Shield Block Chance by 12%";
	skill_nodes[_skillInd].full = 4;
	skill_nodes[_skillInd].on_increment = function(node){
		/// increase life
		PLAYER_SKILLS.shield1 = node.points * 0.12;
	}
	_skillInd++;
	
	skill_nodes[_skillInd].name = "SHLD.2";
	skill_nodes[_skillInd].desc = "Reduce damage when blocking by 15%";
	skill_nodes[_skillInd].full = 2;
	skill_nodes[_skillInd].on_increment = function(node){
		/// increase life
		PLAYER_SKILLS.shield2 = node.points * 0.15;
	}
	_skillInd++;
	
	skill_nodes[_skillInd].name = "HP.2";
	skill_nodes[_skillInd].desc = "Life regeneration increased by 1%";
	skill_nodes[_skillInd].full = 2;
	skill_nodes[_skillInd].on_increment = function(node){
		/// increase life
		PLAYER_SKILLS.regen = node.points * 0.01;
	}
	_skillInd++;
	
	skill_nodes[_skillInd].name = "HP.3";
	skill_nodes[_skillInd].desc = "Life on hit increased by 7%";
	skill_nodes[_skillInd].full = 2;
	skill_nodes[_skillInd].on_increment = function(node){
		/// increase life
		PLAYER_SKILLS.steal = node.points * 0.07;
	}
	_skillInd++;
	//------------------------ Stamina and Speed Nodes
	skill_nodes[_skillInd].name = "SPD.1";
	skill_nodes[_skillInd].desc = "Increase move speed by 1%";
	skill_nodes[_skillInd].full = 15;
	skill_nodes[_skillInd].on_increment = function(node){
		/// increase life
		PLAYER_SKILLS.speed = node.points * 0.01;
	}
	_skillInd++;
	
	skill_nodes[_skillInd].name = "STM.1";
	skill_nodes[_skillInd].desc = "Increase stamina by 10%";
	skill_nodes[_skillInd].full = 10;
	skill_nodes[_skillInd].on_increment = function(node){
		/// increase life
		PLAYER_SKILLS.stamina = node.points * 0.1;
	}
	_skillInd++;
	
	skill_nodes[_skillInd].name = "STM.2";
	skill_nodes[_skillInd].desc = "Increase stamina regen 10%";
	skill_nodes[_skillInd].full = 5;
	skill_nodes[_skillInd].on_increment = function(node){
		/// increase life
		PLAYER_SKILLS.stmRegen = node.points * 0.1;
	}
	_skillInd++;
	
	skill_nodes[_skillInd].name = "RST.1";
	skill_nodes[_skillInd].desc = "Increase consumable potentcy by 20%";
	skill_nodes[_skillInd].full = 5;
	skill_nodes[_skillInd].on_increment = function(node){
		/// increase life
		PLAYER_SKILLS.potentcy = node.points * 0.2;
	}
	_skillInd++;
	
	
}
