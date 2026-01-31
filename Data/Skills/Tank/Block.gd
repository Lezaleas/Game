extends Skill
class_name Block

# reduces damage

func Attack(command: CmdAttack) -> CmdAttack:
	if owner == command.defender:
		command.damage = max(command.damage - power, 0)
	return command
