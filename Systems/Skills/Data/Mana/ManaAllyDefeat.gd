@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaAllyDefeat

func _init() -> void:
	if skill_name == "":
		skill_name = "ManaAllyDefeat"
	if description == "":
		description = "Gains mana when an ally is defeated in a clash."
	if power == 0:
		power = 5.0
	if order == 0:
		order = 50

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner.are_allied(command.loser):
		owner.parent.reservoirs[element].gain_mana(power)
	return command
