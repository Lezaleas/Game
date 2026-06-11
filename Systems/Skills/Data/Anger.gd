extends Skill
class_name Anger

# when damaged, gain a stack. when clashing, convert all stacks into power

func ClashLink(command: CmdClashLink) -> CmdClashLink:
	if owner == command.winner or owner == command.loser:
		owner.attributes[Defines.ATTRIBUTE.Pwr].increase_base(-power * stacks)
		stacks = 0
		entry("clashed and has %s stacks" % stacks)
	return command
		
func SelfReceiveDmg(command: CmdReceiveDmg) -> CmdReceiveDmg:
	stacks += 1
	#Log.entry("%s - %s is gaining %s power" % [skill_name, owner, stacks], 1)
	owner.attributes[Defines.ATTRIBUTE.Pwr].increase_base(power)
	return command
	
var stacks: int = 0
