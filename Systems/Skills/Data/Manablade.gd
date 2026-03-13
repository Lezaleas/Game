extends Skill
class_name Manablade

# Manablade: when winning a clash, attack the loser

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	if command.winner == owner:
		Situation.attack_handler.cast(owner, element, power, Defines.TARGETING_TYPE.Choose, command.loser)
		entry("followed up winning a clash with an attack on %s" % command.loser)
	return command
