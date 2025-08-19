extends Node2D

var fighter_state: FighterState

func _ready():
	print("Fighter visual node: ", %Sprite)

func _process(_delta):
	if fighter_state:
		self.position.x = fighter_state.position_x
		self.position.y = fighter_state.position_y
