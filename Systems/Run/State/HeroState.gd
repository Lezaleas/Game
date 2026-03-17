extends Resource
class_name HeroState

var id: int
@export var sprite: SpriteFrames
@export var skills: Array[Skill] = []
@export var passives: Array[Skill] = []
@export var attributes_base = [10,10,10,10]
@export var attributes_mult = [1,1,1,1]
var perk_points: int = 0

func increase_attribute_base(amount:int, attribute:Defines.ATTRIBUTE) -> void:
	attributes_base[attribute] += amount
	
func increase_attribute_mult(amount:int, attribute:Defines.ATTRIBUTE) -> void:
	attributes_mult[attribute] += amount
	
func grant_skill(skill:Skill) -> void:
	skills.append(skill)
	
func grant_passive(passive:Skill) -> void:
	passive.show_to_player = false
	passives.append(passive)
