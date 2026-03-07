extends Skill
class_name FrostShield

func _init() -> void:
	order = 100
	power = 250

func Attack(command: CmdAttack) -> CmdAttack:
	if owner == command.defender:
		command.damage = min(power, command.damage)
		entry("received damage and capped it")
	return command
