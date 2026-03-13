extends Skill
class_name Jump

# jump every 5 seconds

var cooldown = 25

func TurnStart(command: CmdTurnStart) -> CmdTurnStart:
	cooldown -= 1
	if cooldown == 0:
		cooldown = 25
		owner.jump(power)
		entry("jumps forward")
	return command
