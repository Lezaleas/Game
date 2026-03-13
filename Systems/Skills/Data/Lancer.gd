extends Skill
class_name Lancer

# Lancer: add my power to allies clashing in engage range of mine

func ClashStart(command: CmdClashStart) -> CmdClashStart:
	var bonus_amount = owner.attributes[Defines.ATTRIBUTE.Pwr].current * power
	
	# Check Blue Side Ally
	if owner.are_allied(command.blue_clasher) and owner != command.blue_clasher:
		if abs(owner.position_x - command.blue_clasher.position_x) <= Defines.CLASH_ENGAGE_RANGE:
			command.blue_strength_bonus += bonus_amount
			entry("provided %s support power to a clashing ally" % int(bonus_amount))
			
	# Check Red Side Ally
	if owner.are_allied(command.red_clasher) and owner != command.red_clasher:
		if abs(owner.position_x - command.red_clasher.position_x) <= Defines.CLASH_ENGAGE_RANGE:
			command.red_strength_bonus += bonus_amount
			entry("provided %s support power to a clashing ally" % int(bonus_amount))
		
	return command
