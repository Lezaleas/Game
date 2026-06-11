extends Skill
class_name Focus

# Every second not damaged, gain a stack. Lose all stacks when getting damage. Stacks increase magic

func TurnStart(command: CmdTurnStart) -> CmdTurnStart:
	stacks += 1
	owner.attributes[Defines.ATTRIBUTE.Spi].increase_mult(power)
	entry("gained a stack of focus")
	return command
		
func SelfReceiveDmg(command: CmdReceiveDmg) -> CmdReceiveDmg:
	owner.attributes[Defines.ATTRIBUTE.Spi].increase_mult(-power * stacks)
	stacks = 0
	entry("got his stacks reset to 0")
	return command
	
var stacks: int = 0
