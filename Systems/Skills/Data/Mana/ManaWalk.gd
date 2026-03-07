@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaWalk

func SelfWalk(command: CmdWalk) -> CmdWalk:
	owner.parent.reservoirs[element].gain_mana(power * command.distance)
	return command
