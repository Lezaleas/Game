extends CmdEvent
class_name CmdApplyBuff

var attacker
var defender: FighterState
var buff: Defines.BUFF
var amount: float

func _init(_attacker, _defender: FighterState, _buff:Defines.BUFF, _amount: float) -> void:
	type = Defines.CMD_EVENT_TYPE.ClashStart
	fighter_trigger = _attacker
	attacker = _attacker
	defender = _defender
	buff = _buff
	amount = _amount
