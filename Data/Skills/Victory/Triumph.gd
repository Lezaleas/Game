extends Skill
class_name Triumph

# multiplies link damage by power when winning a clash

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	command.damage_mult *= power
	Log.entry("won a clash and allies deal more damage")
	return command
