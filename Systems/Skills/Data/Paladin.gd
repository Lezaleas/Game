extends Skill
class_name Paladin

# Paladin: gain 5% defense after clashing. lose all stacks of this skill on ally clashing

var stacks: int = 0

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	stacks += 1
	owner.attributes[Defines.ATTRIBUTE.Wis].increase_mult(power)
	entry("gained defense after clashing. Current stacks: %s" % stacks)
	return command

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	# If any ally (winner or loser) is clashing, and it's NOT the owner of this skill
	var is_ally_winner = owner.are_allied(command.winner)
	var is_ally_loser = owner.are_allied(command.loser)
	
	if (is_ally_winner or is_ally_loser) and command.winner != owner and command.loser != owner:
		if stacks > 0:
			owner.attributes[Defines.ATTRIBUTE.Wis].increase_mult(-power * stacks)
			entry("lost %s stacks of defense because an ally clashed" % stacks)
			stacks = 0
	return command
