extends Node2D
class_name FighterView

var fighter_state: FighterState
var id = 0 as int

func _ready():
	add_to_group("refresh")
	
func refresh_battle_started():
	fighter_state = Situation.fighters[id]
	self.position.y = fighter_state.position_y
	pass

func refresh(_delta):
	self.position.x = fighter_state.position_x
