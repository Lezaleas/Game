extends Skill
class_name Jump

# jump every 10 turns

var cooldown = 5

func _init() -> void:
	power = 100

func TurnStart(command: CmdTurnStart) -> CmdTurnStart:
	cooldown -= 1
	if cooldown == 0:
		cooldown = 5
		owner.jump(power)
		entry("jumps forward")
	return command
