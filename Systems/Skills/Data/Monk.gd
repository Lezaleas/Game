extends Skill
class_name Monk

# Monk: every x clashes lost, trigger a link attack from allies on the clash winner

var losses: int = 0

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if command.loser == owner:
		losses += 1
		if losses >= int(power):
			var allies = owner.get_allied_team().fighters
			var attackers_count = 0
			for ally in allies:
				if ally != owner:
					Situation.attack_handler.cast(ally, element, 1.0, Defines.TARGETING_TYPE.Choose, command.winner, [AttackHandler.Tag.COUNTER])
					attackers_count += 1
			
			if attackers_count > 0:
				entry("lost another clash (%s total) and allies retaliated against %s" % [losses, command.winner])
			
			losses = 0
	return command
