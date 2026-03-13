extends Skill
class_name Sergeant

# Sergeant: when winning a clash, allies except me regain stamina

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	if command.winner == owner:
		var allies = owner.get_allied_team().fighters
		var recovered_count = 0
		for ally in allies:
			if ally != owner:
				ally.gain_stamina(power)
				recovered_count += 1
		
		if recovered_count > 0:
			entry("won a clash and inspired %s allies to regain %s stamina" % [recovered_count, power])
			
	return command
