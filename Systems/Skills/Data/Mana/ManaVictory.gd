@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaVictory

func _init() -> void:
	if skill_name == "":
		skill_name = "ManaVictory"
	if description == "":
		description = "Gains mana when you win a clash."
	if power == 0:
		power = 10.0
	if order == 0:
		order = 50

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	owner.parent.reservoirs[element].gain_mana(power)
	return command
