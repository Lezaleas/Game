extends Resource
class_name TeamState

var id: int
var parent: BattleState
var fighters = [] as Array[FighterState]
var reservoirs = [] as Array[ReservoirState]
## blue side is 1, red side is -1
var direction: int

func setup() -> void:
	if id == 0:
		direction = 1
	elif id == 1:
		direction = -1

func get_rightmost_fighter() -> FighterState:
	var rightmost_fighter: FighterState = null
	for f in fighters:
		if not rightmost_fighter or f.position_x > rightmost_fighter.position_x:
			rightmost_fighter = f
	return rightmost_fighter

func get_leftmost_fighter() -> FighterState:
	var leftmost_fighter: FighterState = null
	for f in fighters:
		if not leftmost_fighter or f.position_x < leftmost_fighter.position_x:
			leftmost_fighter = f
	return leftmost_fighter

func _to_string() -> String:
	return("Team: " + str(id))
