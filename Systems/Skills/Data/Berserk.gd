extends Skill
class_name Berserk

# Berserk: the lower your stamina is, boost link damage% on clash win

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	var missing_stamina = 100 - owner.stamina
	var bonus_mult = missing_stamina * power
	
	if bonus_mult > 0:
		command.damage_mult *= (1.0 + bonus_mult)
		entry("boosted link damage by %s%% due to low stamina" % [int(bonus_mult * 100)])
			
	return command
