extends CmdEvent
class_name CmdWalk

var fighter: FighterState
var distance: float

func _init(_fighter:FighterState, _distance:float) -> void:
	type = Defines.CMD_EVENT_TYPE.Walk
	fighter_trigger = _fighter
	fighter = _fighter
	distance = _distance
