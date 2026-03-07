@icon("res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres")
extends Skill
class_name ManaFractionDamage

func TurnStart(command: CmdTurnStart) -> CmdTurnStart:
	var fraction = get_fighter_damage_fraction(owner)
	owner.parent.reservoirs[element].gain_mana(power * fraction)
	return command

func get_fighter_damage_fraction(fighter: FighterState) -> float:
	var allied_team = fighter.get_allied_team().fighters
	var total_team_spi_dmg = 0.0
	for ally_fighter in allied_team:
		total_team_spi_dmg += ally_fighter.dmg_del
	if total_team_spi_dmg == 0:
		return 0.25
	return fighter.dmg_del / total_team_spi_dmg
