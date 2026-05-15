extends CmdEvent
class_name CmdClashCrit

var blue_clasher: FighterState
var red_clasher: FighterState
var is_critical: bool = false
var critical_mult: float = 2.0

func _init(blue: FighterState, red: FighterState) -> void:
	type = Defines.CMD_EVENT_TYPE.ClashCrit
	fighter_trigger = null
	blue_clasher = blue
	red_clasher = red
