@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaHighestDamage

func TurnStart(command: CmdTurnStart) -> CmdTurnStart:
	owner.parent.reservoirs[element].gain_mana(power * highest_damage)
	return command
	
func SelfDealDmg(command: CmdDealDmg) -> CmdDealDmg:
	highest_damage = max(command.damage, highest_damage)
	return command

var highest_damage: float = 0
