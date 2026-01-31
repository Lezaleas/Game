@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaDefeat

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner == command.loser:
		owner.parent.reservoirs[element].gain_mana(power)
	return command
