extends Skill
class_name SkillExample

func Walk(command: CmdEvent) -> CmdEvent:
	if command.fighter == owner:
		command.distance = 0
	return command
