extends Skill
class_name Domination

# winning 2 clashes in a row reduces enemy mana

var won_previous: bool = false

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner == command.winner:
		if won_previous:
			var enemy_team: TeamState = owner.get_enemy_team()
			var enemy_mana: ReservoirState = enemy_team.reservoirs[element] as ReservoirState
			enemy_mana.gain_mana(-power)
			won_previous = false
		else:
			won_previous = true
	if owner == command.loser:
		won_previous = false
	Log.entry("won 2 clash in a row and enemies lose mana")
	return command
