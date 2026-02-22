extends CmdEvent
class_name CmdClashStart

var blue_clasher: FighterState
var red_clasher: FighterState

func _init(blue_side_clasher: FighterState, red_side_clasher: FighterState) -> void:
	type = Defines.CMD_EVENT_TYPE.ClashStart
	fighter_trigger = null
	blue_clasher = blue_side_clasher
	red_clasher = red_side_clasher
