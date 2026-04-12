extends CmdEvent
class_name CmdReceiveDmg

var damage: float
var fighter: FighterState

func _init(_fighter: FighterState, _damage: float, _tags: Array = []) -> void:
	type = Defines.CMD_EVENT_TYPE.ReceiveDmg
	fighter_trigger = _fighter
	fighter = _fighter
	damage = _damage
	tags = _tags
