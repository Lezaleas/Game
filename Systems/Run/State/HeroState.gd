extends Resource
class_name HeroState

@export var id: int
@export var sprite: SpriteFrames
@export var skills: Array[Skill] = []
@export var passives: Array[Skill] = []
@export var attributes_base = [0,0,0,0, 0,0,0,0,0,0,0] # hardcoded stats size
@export var attributes_mult = [1,1,1,1, 1,1,1,1,1,1,1]
@export var perk_points: Array[int] = [0,0,0,0]
@export var perk_trees: Array[PerkTree]
@export var unlocked_perks: Array[Perk]
@export var equipment_slots: Array[EquipmentState] = [null,null,null,null]
@export var weight: int = 0
@export var critter: Critter

func setup():
	if not perk_trees:
		perk_trees = RunManager.shrines.duplicate()
	for x in range(perk_trees.size()):
		perk_trees[x] = perk_trees[x].duplicate(true)
		perk_trees[x].setup(id, x)
	if not critter:
		var crit:Critter
		match id:
			0: crit = load("res://Systems/Run/Data/Critters/Agumon_Stage0.tres")
			1: crit = load("res://Systems/Run/Data/Critters/Gazimon_Stage0.tres")
			2: crit = load("res://Systems/Run/Data/Critters/Elecmon_Stage0.tres")
			3: crit = load("res://Systems/Run/Data/Critters/Tentomon_Stage0.tres")
		crit.equip_to_hero(self)
		
func reset_all() -> void:
	reset_perk_trees()
	reset_skills()
	
func reset_skills() -> void:
	skills.clear()
	for tree in perk_trees:
		for tier in tree.tiers:
			for perk in tier.perks:
				if perk.unlocked:
					if perk.effects[0] is SkillPerk:
						grant_skill(perk.effects[0].skill)
		
func reset_perk_trees():
	var new_perk_trees: Array[PerkTree] = []
	for x in range(RunManager.heroes.size()):
		if RunManager.heroes[x].critter:
			new_perk_trees.append(RunManager.heroes[x].critter.perk_tree.duplicate(true))
			var unlock_position: = perk_trees[x].get_unlock_position()
			new_perk_trees[x].set_unlock_position(unlock_position)
	for item in equipment_slots:
		if item:
			if item.skill:
				new_perk_trees[item.type].convert_to_equipment_skill(item.skill)
	for x in range(perk_trees.size()):
		new_perk_trees[x].setup(id, x)
	perk_trees = new_perk_trees
		
func swap_perk_tree(new_tree:PerkTree, position:int) -> void:
	var unlocked_perk_index = -1
	for tier in perk_trees[position].tiers:
		for perk in tier.perks:
			if perk.unlocked:
				unlocked_perk_index = perk.tier_index
				remove_perk(perk)
	perk_trees[position] = new_tree.duplicate(true)
	perk_trees[position].setup(id, position)
	if unlocked_perk_index >= 0:
		var new_perk = perk_trees[position].tiers[unlocked_perk_index].perks[0]
		unlock_perk(new_perk)
		new_perk.unlocked = true
		
func reset_item_stats() -> void:
	pass
		
func equip(item:EquipmentState) -> void:
	unequip(item.type)
	equipment_slots[item.type] = item
	weight += item.weight
	if item.skill: reset_all()
	
func unequip(type:Defines.EQUIP_TYPE) -> void:
	var item = equipment_slots[type]
	if not item: return
	weight -= item.weight
	equipment_slots[type] = null
	if item.skill: reset_all()

func get_total_perk_points() -> Array[int]:
	var result: Array[int] = [0, 0, 0, 0] # hardcoded stats size
	for item in equipment_slots:
		if item:
			for i in range(4): # hardcoded stats size
				result[i] += item.perk_points[i]
	return result
	
func update_perk_points() -> void:
	perk_points = get_total_perk_points()
	for x in range(perk_points.size()):
		perk_trees[x].perk_points = perk_points[x]
	
func get_equip_attributes() -> Array[int]:
	var result: Array[int] = []
	for x in range(Defines.ATTRIBUTE.size()):
		var sum: = 0
		for equipment in equipment_slots:
			if equipment:
				sum += equipment.attributes[x]
		result.append(sum)
	return result
		
func unlock_perk(perk:Perk) -> void:
	if perk not in unlocked_perks:
		unlocked_perks.append(perk)
		perk.unlock_or_remove(true)
		
func remove_perk(perk:Perk) -> void:
	unlocked_perks.erase(perk)
	perk.unlock_or_remove(false)

func increase_attribute_base(amount:int, attribute:Defines.ATTRIBUTE) -> void:
	attributes_base[attribute] += amount
	
func increase_attribute_mult(amount:int, attribute:Defines.ATTRIBUTE) -> void:
	attributes_mult[attribute] += amount
	
func grant_skill(skill:Skill) -> void:
	skills.append(skill)
	
func remove_skill(skill:Skill) -> void:
	skills.erase(skill)
	
func grant_passive(passive:Skill) -> void:
	passive.show_to_player = false
	passives.append(passive)
	
func _to_string() -> String:
	return ("Hero State: " + str(id))
