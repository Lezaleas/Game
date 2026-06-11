extends Skill
class_name Hexstrike

# Attack an enemy that got debuffed

func ApplyBuff(command: CmdApplyBuff) -> CmdApplyBuff:
	if command.defender in owner.get_enemy_team().fighters:
		if AttackHandler.Tag.COUNTER in command.tags:
			return command
			
		Situation.attack_handler.cast(owner,element,power,Defines.TARGETING_TYPE.Choose,command.defender, [AttackHandler.Tag.COUNTER])
		#Log.entry("hexstrike casted on %s" % [command.defender], 1)
	return command
