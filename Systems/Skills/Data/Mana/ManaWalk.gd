@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaWalk

func _init() -> void:
	if skill_name == "":
		skill_name = "ManaWalk"
	if description == "":
		description = "Gains mana according to distance traveled."
	if power == 0:
		power = 0.5
	if order == 0:
		order = 50

func SelfWalk(command: CmdWalk) -> CmdWalk:
	owner.parent.reservoirs[element].gain_mana(power * command.distance)
	return command
