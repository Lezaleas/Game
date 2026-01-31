@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaVictory

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	owner.parent.reservoirs[element].gain_mana(power)
	return command
