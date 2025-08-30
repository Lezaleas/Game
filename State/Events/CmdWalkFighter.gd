extends CmdEvent
class_name CmdWalk

var fighter: FighterState
var distance: float

func _init(fighter_to_walk:FighterState, distance_to_walk:float) -> void:
	type = Defines.CMD_EVENT_TYPE.Walk
	fighter = fighter_to_walk
	distance = distance_to_walk
