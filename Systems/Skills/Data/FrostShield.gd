extends Skill
class_name FrostShield

# caps damage received at some value

func Attack(command: CmdAttack) -> CmdAttack:
	if owner == command.defender:
		command.damage = min(power, command.damage)
		entry("received damage and capped it")
	return command
