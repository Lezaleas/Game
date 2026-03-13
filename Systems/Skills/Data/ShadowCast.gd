extends Skill
class_name ShadowCast

var cooldown: int = 50

# cast an attack every 10 seconds

func TurnStart(command: CmdTurnStart) -> CmdTurnStart:
	cooldown -= 1
	if cooldown == 0:
		cooldown = 50
		Situation.attack_handler.cast(owner, element, power, Defines.TARGETING_TYPE.Leader)
		entry("casts an attack")
	return command
