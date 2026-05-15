extends CmdEvent
class_name CmdClashEvasion

var blue_clasher: FighterState
var red_clasher: FighterState
var is_evaded: bool = false

func _init(blue: FighterState, red: FighterState) -> void:
	type = Defines.CMD_EVENT_TYPE.ClashEvasion
	fighter_trigger = null
	blue_clasher = blue
	red_clasher = red
