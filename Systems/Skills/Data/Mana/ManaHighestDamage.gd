@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaHighestDamage

func _init() -> void:
	if skill_name == "":
		skill_name = "ManaHighestDamage"
	if description == "":
		description = "Gains mana based on your highest single-hit damage recorded."
	if power == 0:
		power = 0.1
	if order == 0:
		order = 50

func TurnStart(command: CmdTurnStart) -> CmdTurnStart:
	owner.parent.reservoirs[element].gain_mana(power * highest_damage)
	return command
	
func SelfDealDmg(command: CmdDealDmg) -> CmdDealDmg:
	highest_damage = max(command.damage, highest_damage)
	return command

var highest_damage: float = 0
