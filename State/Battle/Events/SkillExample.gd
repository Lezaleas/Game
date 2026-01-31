extends Skill
class_name SkillExample

func SelfWalk(command: CmdWalk) -> CmdWalk:
	command.distance = 0
	return command
