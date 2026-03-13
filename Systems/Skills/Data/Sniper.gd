extends Skill
class_name Sniper

# Sniper: gain damage boost on attacks based on distance to the target

func SelfAttack(command: CmdAttack) -> CmdAttack:
	var dist = abs(owner.position_x - command.defender.position_x)
	var bonus_mult = dist * power / 100
	
	if bonus_mult > 0:
		command.damage *= (1.0 + bonus_mult)
		entry("calculated trajectory for distance %s, gaining %s%% damage boost" % [int(dist), int(bonus_mult * 100)])
		
	return command
