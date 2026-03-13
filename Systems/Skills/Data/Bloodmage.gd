extends Skill
class_name Bloodmage

# Bloodmage: Every x attacks received, counterattack

var received_attacks: int = 0

func Attack(command: CmdAttack) -> CmdAttack:
	if command.defender == owner:
		received_attacks += 1
		if received_attacks >= int(power):
			entry("blood boiled after receiving %s attacks, counterattacking %s!" % [received_attacks, command.attacker])
			
			# Trigger counterattack
			Situation.attack_handler.cast(owner, element, 1.0, Defines.TARGETING_TYPE.Choose, command.attacker)
			
			received_attacks = 0
	return command
