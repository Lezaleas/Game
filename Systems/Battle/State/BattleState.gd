extends Resource
class_name BattleState

var teams: Array[TeamState]
var turn: int = 0
var finished: = false
var won: = true

enum BattleType { HUNT, ARENA, BOSS, RITUAL, EXPEDITION }
var _battle_type: BattleType = BattleType.HUNT
var simulation: bool = false
var battle_type: BattleType:
	get:
		return _battle_type
	set(value):
		_battle_type = value
		simulation = (value == BattleType.ARENA)
