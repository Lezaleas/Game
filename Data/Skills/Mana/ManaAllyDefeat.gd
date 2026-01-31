@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaAllyDefeat

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner.are_allied(command.loser):
		owner.parent.reservoirs[element].gain_mana(power)
	return command
