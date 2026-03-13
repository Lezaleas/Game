extends Skill
class_name BloodRush

# BloodRush: if you deal more than x damage, regain x stamina

@export var stamina_to_gain: float = 0.0

func SelfDealDmg(command: CmdDealDmg) -> CmdDealDmg:
	if command.damage > power:
		owner.gain_stamina(stamina_to_gain)
		entry("felt the rush! Gained %s stamina after dealing %s damage" % [int(stamina_to_gain), int(command.damage)])
	return command
