@icon("res://Assets/Sprites/Common/ElementalIcons/Red.tres")
extends Resource
class_name Skill

@export var skill_name: String
@export_multiline var description: String
@export var power: float = 0.0
@export var order: int = 0		# smaller goes first
@export var mana_cost:int = 0
var show_to_player: bool = true
var owner: FighterState
var element: int = 0

func _to_string():
	return (skill_name)

func entry(log_entry: String) -> void:
	Log.entry(skill_name + " - " + str(owner) + " " + log_entry, 1)
