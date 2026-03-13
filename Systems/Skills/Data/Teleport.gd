extends Skill
class_name Teleport

# Teleport: use magic instead of agility to move

func SelfWalk(command: CmdWalk) -> CmdWalk:
	var magic_val = owner.attributes[Defines.ATTRIBUTE.Spi].current # Using Spirit as magic
	var direction = owner.direction
	
	# Recalculate distance using magic instead of agility
	command.distance = magic_val * power * direction * Defines.MOVE_SPEED
	
	entry("warped time to walk %s distance using magic" % int(abs(command.distance)))
	return command
