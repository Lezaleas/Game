extends CmdEvent
class_name CmdAttack

var attacker: FighterState
var defender: FighterState
var damage: float

func _init(_attacker: FighterState, _defender: FighterState, _damage: float) -> void:
	type = Defines.CMD_EVENT_TYPE.ClashStart
	fighter_trigger = _attacker
	attacker = _attacker
	defender = _defender
	damage = _damage
