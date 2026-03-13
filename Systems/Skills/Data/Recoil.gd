extends Skill
class_name Recoil

# Recoil: boost damage, but jump backwards on casting attacks

@export var distance: int

func SelfAttack(command: CmdAttack) -> CmdAttack:
	command.damage *= (1.0 + power)
	
	# Jump backwards (negative distance relative to facing direction)
	owner.jump(-distance)
	
	entry("recoiled from the blast, gaining %s%% damage but losing ground!" % int(power * 100))
	return command
