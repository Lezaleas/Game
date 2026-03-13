extends Skill
class_name Rogue

# Rogue: gain power stacks the less stamina your clashing opponent has. 
# after winning a clash, boost links the less stamina the loser has and lose all stacks

var stacks: float = 0.0

func ClashStart(command: CmdClashStart) -> CmdClashStart:
	if command.blue_clasher == owner or command.red_clasher == owner:
		var opponent = command.red_clasher if command.blue_clasher == owner else command.blue_clasher
		var gain = (100 - opponent.stamina) * power
		stacks += gain
		owner.attributes[Defines.ATTRIBUTE.Pwr].increase_base(gain)
		entry("observed opponent's weakness and gained %s power stacks. Total: %s" % [int(gain), int(stacks)])
	return command

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	# Only triggers if owner is winner
	var bonus = (100 - command.loser.stamina) * power
	command.damage_mult *= (1.0 + bonus)
	entry("exploited opening with %s%% damage boost and resetting %s power stacks" % [int(bonus * 100), int(stacks)])
	
	# Reset stacks
	owner.attributes[Defines.ATTRIBUTE.Pwr].increase_base(-stacks)
	stacks = 0
	return command
