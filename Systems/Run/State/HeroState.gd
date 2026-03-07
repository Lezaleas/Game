extends Resource
class_name HeroState

var id: int
var sprite: AnimatedSprite2D
var skills: Array[Skill] = []
var passives: Array[Skill] = []
var attributes_base = []
var attributes_mult = []

func _init() -> void:
	for x in range (Defines.ATTRIBUTE.size()):
		attributes_base.append(Defines.ATTRIBUTE_STARTING)
		attributes_mult.append(1)
	skills = [(Defines.skills.regular_skills[1])]

func increase_attribute_base(amount:int, attribute:Defines.ATTRIBUTE) -> void:
	attributes_base[attribute] += amount
	
func increase_attribute_mult(amount:int, attribute:Defines.ATTRIBUTE) -> void:
	attributes_mult[attribute] += amount
	
func grant_skill(skill:Skill) -> void:
	skills.append(skill)
	
func grant_passive(passive:Skill) -> void:
	passive.show_to_player = false
	passives.append(passive)
