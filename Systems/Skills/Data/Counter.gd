extends Skill
class_name Counter

# when losing a clash, cast a link attack

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner == command.loser:
		Situation.attack_handler.cast(owner, element, 1, Defines.TARGETING_TYPE.Choose, command.winner, [AttackHandler.Tag.COUNTER])
		entry("attacks the clash winner")
	return command
