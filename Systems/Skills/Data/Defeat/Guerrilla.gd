extends Skill
class_name Guerrilla

# when losing a clash, the winner loses stamina

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner == command.loser:
		command.winner.gain_stamina(-power)
		entry("lost a clash and sapped stamina")
	return command
