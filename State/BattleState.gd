extends Node
class_name BattleState

# Properties to hold the state of the battle
var all_fighters : Array[FighterState] = []
var blue_fighters: Array[FighterState] = []
var red_fighters: Array[FighterState] = []
var turn_number = 0
