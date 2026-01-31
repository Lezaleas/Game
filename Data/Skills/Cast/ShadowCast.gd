extends Skill
class_name ShadowCast

var cooldown: int = 10

# cast an attack every 10 turns

func TurnStart(command:CmdTurnStart) -> CmdTurnStart:
	cooldown -= 1
	if cooldown == 0:
		cooldown = 10
		Situation.attack_handler.cast(owner, element, 1, Defines.TARGETING_TYPE.Leader)
		entry("casts an attack")
	return command
