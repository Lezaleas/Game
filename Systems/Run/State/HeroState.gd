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

func setup():
	perk_trees = RunManager.shrines.duplicate()
	for x in range(perk_trees.size()):
		perk_trees[x] = perk_trees[x].duplicate(true)
		perk_trees[x].setup(id, x)
	match id:
		0: sprite = load("res://Assets/Sprite_frames/Stage1/Greymon.tres")
		1: sprite = load("res://Assets/Sprite_frames/Stage1/Garurumon.tres")
		2: sprite = load("res://Assets/Sprite_frames/Stage1/Birdramon.tres")
		3: sprite = load("res://Assets/Sprite_frames/Stage1/Airdramon.tres")
		
func equip(item:EquipmentState) -> void:
	unequip(item.type)
	equipment_slots[item.type] = item
	weight += item.weight
	if item.skill: skills.append(item.skill)
	
func unequip(type:Defines.EQUIP_TYPE) -> void:
	var item = equipment_slots[type]
	if item:
		weight -= item.weight
	equipment_slots[type] = null
	if item.skill: skills.erase(item.skill)

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
