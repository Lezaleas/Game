extends CmdEvent
class_name CmdAttackEvasion

var attacker: FighterState
var defender: FighterState
var is_evaded: bool = false

func _init(_attacker: FighterState, _defender: FighterState) -> void:
	type = Defines.CMD_EVENT_TYPE.AttackEvasion
	fighter_trigger = _attacker
	attacker = _attacker
	defender = _defender
