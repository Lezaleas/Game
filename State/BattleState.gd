extends Resource
class_name BattleState

# Properties to hold the state of the battle
var team1_fighters: Array[FighterState] = []
var team2_fighters: Array[FighterState] = []
var turn_number = 0
