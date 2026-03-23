extends Resource
class_name HeroState

var id: int
@export var sprite: SpriteFrames
var skills: Array[Skill] = []
var passives: Array[Skill] = []
@export var attributes_base = [10,10,10,10]
var attributes_mult = [1,1,1,1]
@export var perk_points: Array[int] = [4,3,2,1]
@export var perk_trees: Array[PerkTree]
var unlocked_perks: Array[Perk]
var equipment_slots: Array[EquipmentState] = [null,null,null,null]

func setup():
	perk_trees = RunManager.shrines.duplicate()
	for x in range(perk_trees.size()):
		perk_trees[x] = perk_trees[x].duplicate(true)
		perk_trees[x].setup(id)
	match id:
		0: sprite = load("res://Assets/Sprite_frames/Stage1/Greymon.tres")
		1: sprite = load("res://Assets/Sprite_frames/Stage1/Garurumon.tres")
		2: sprite = load("res://Assets/Sprite_frames/Stage1/Birdramon.tres")
		3: sprite = load("res://Assets/Sprite_frames/Stage1/Airdramon.tres")
		
func equip(item:EquipmentState) -> void:
	unequip(item.type)
	equipment_slots[item.type] = item
	
func unequip(type:Defines.EQUIP_TYPE) -> void:
	equipment_slots[type] = null
	
func get_equip_attributes() -> Array[int]:
	var result: Array[int] = []
	for x in Defines.ATTRIBUTE.values():
		var sum: = 0
		for equipment in equipment_slots:
			if equipment:
				sum += equipment.attributes[x]
		result.append(sum)
	return result
		
func unlock_perk(perk:Perk) -> void:
	if perk not in unlocked_perks:
		unlocked_perks.append(perk)
		
func remove_perk(perk:Perk) -> void:
	unlocked_perks.erase(perk)

func increase_attribute_base(amount:int, attribute:Defines.ATTRIBUTE) -> void:
	attributes_base[attribute] += amount
	
func increase_attribute_mult(amount:int, attribute:Defines.ATTRIBUTE) -> void:
	attributes_mult[attribute] += amount
	
func grant_skill(skill:Skill) -> void:
	skills.append(skill)
	
func grant_passive(passive:Skill) -> void:
	passive.show_to_player = false
	passives.append(passive)
	
func _to_string() -> String:
	return ("Hero State: " + str(id))
