extends Resource
class_name BattleState

var teams: Array[TeamState]
var turn: int = 0
var battle_type: BattleType

enum BattleType {HUNT, ARENA, BOSS}
