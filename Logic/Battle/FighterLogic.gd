extends Node
class_name FighterZZHandler

func walk_forward(fighter: FighterState) -> void:
	var distance = fighter.attributes[3].current * fighter.parent.direction * Defines.MOVE_SPEED as float
	#region Walk Event
	var cmd_walk = CmdWalk.new(fighter, distance)
	cmd_walk = Situation.skills.resolve(cmd_walk)
	if cmd_walk.is_cancelled: return
	distance = cmd_walk.distance
	#endregion
	fighter.position_x += distance
