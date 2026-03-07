extends CmdEvent
class_name CmdClashLink

var links: Array[FighterState]
var loser: FighterState
var winner: FighterState
var damage_mult

func _init(_winner:FighterState, _links:Array[FighterState], _loser:FighterState, _damage_mult:float) -> void:
	type = Defines.CMD_EVENT_TYPE.ClashStart
	fighter_trigger = _winner
	links = _links
	loser = _loser
	winner = _winner
	damage_mult = _damage_mult
