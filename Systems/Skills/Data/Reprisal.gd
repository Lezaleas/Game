extends Skill
class_name Reprisal

# when ally loses a clash, attack the winner

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner.are_allied(command.loser):
		Situation.attack_handler.cast(owner, element, 1, Defines.TARGETING_TYPE.Choose, command.winner)
		entry("counter attacks after %s lost a clash" % command.loser)
	return command
