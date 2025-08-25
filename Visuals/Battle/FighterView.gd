extends Node2D
class_name FighterView

var fighter_state: FighterState
var id = 0 as int

func _ready():
	self.position.y = fighter_state.position_y
	Log.entry(self.name + " initialized")

func _process(_delta):
	self.position.x = fighter_state.position_x
