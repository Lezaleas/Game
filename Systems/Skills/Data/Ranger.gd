extends Skill
class_name Ranger

# Ranger: the lower your stamina is, gain magic%

func SelfAttack(command: CmdAttack) -> CmdAttack:
	var missing_stamina = 100 - owner.stamina
	var bonus_mult = missing_stamina * power
	
	if bonus_mult > 0:
		command.damage *= (1.0 + bonus_mult)
		entry("gained %s%% magic damage due to low stamina" % [int(bonus_mult * 100)])
		
	return command
