extends Resource
class_name Skill

@export var skill_name: String
@export var description: String
@export var order: int = 0		# smaller goes first
var show_to_player: bool = true
var owner: FighterState

func _to_string():
	return ("Skill: " + skill_name)
