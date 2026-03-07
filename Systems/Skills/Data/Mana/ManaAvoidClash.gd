@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaAvoidClash

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner == command.winner or owner == command.loser:
		owner.parent.reservoirs[element].gain_mana(power * stacks)
		stacks = 0
	else:
		stacks += 1
	return command

var stacks: int = 0
