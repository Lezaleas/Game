extends Skill
class_name Adrenaline

# Gain stamina when losing a clash

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner == command.loser:
		owner.gain_stamina(power)
		Log.entry("%s - %s gained stamina" % [skill_name, owner], 1)
	return command
