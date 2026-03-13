@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaDefeat

func _init() -> void:
	if skill_name == "":
		skill_name = "ManaDefeat"
	if description == "":
		description = "Gains mana when you lose a clash."
	if power == 0:
		power = 10.0
	if order == 0:
		order = 50

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner == command.loser:
		owner.parent.reservoirs[element].gain_mana(power)
	return command
