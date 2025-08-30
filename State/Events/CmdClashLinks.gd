extends CmdEvent
class_name CmdClashLink

var attackers: Array[FighterState]
var defender: FighterState
var clash_winner: FighterState
var damage_mult

func _init(_clash_winner:FighterState, _attackers:Array[FighterState], _defender:FighterState, _damage_mult:float) -> void:
	type = Defines.CMD_EVENT_TYPE.ClashStart
	attackers = _attackers
	defender = _defender
	clash_winner = _clash_winner
	damage_mult = _damage_mult
