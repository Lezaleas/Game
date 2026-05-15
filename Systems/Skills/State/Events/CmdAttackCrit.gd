extends CmdEvent
class_name CmdAttackCrit

var attacker: FighterState
var defender: FighterState
var is_critical: bool = false
var critical_mult: float = 2.0

func _init(_attacker: FighterState, _defender: FighterState) -> void:
	type = Defines.CMD_EVENT_TYPE.AttackCrit
	fighter_trigger = _attacker
	attacker = _attacker
	defender = _defender
