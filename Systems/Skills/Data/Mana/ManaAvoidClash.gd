@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaAvoidClash

func _init() -> void:
	if skill_name == "":
		skill_name = "ManaAvoidClash"
	if description == "":
		description = "Gains mana over time as long as you avoid clashing. Reset on clash."
	if power == 0:
		power = 1.0
	if order == 0:
		order = 50

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner == command.winner or owner == command.loser:
		owner.parent.reservoirs[element].gain_mana(power * stacks)
		stacks = 0
	else:
		stacks += 1
	return command

var stacks: int = 0
