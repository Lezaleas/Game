extends CmdEvent
class_name CmdDealDmg

var damage: float
var fighter: FighterState

func _init(_fighter: FighterState, _damage: float) -> void:
	type = Defines.CMD_EVENT_TYPE.DealDmg
	fighter = _fighter
	damage = _damage
