extends Node
class_name BattleSimulator

@onready var fighter_logic = %Fighter as FighterLogic
@onready var state = %State as BattleState

func _ready():
	EventBus.subscribe("turn_started", self)

# Processes a single turn of the battle
func on_turn_started():
	Log.entry("--- Turn: %d ---" % state.turn_number)
	Log.entry("Positions: %s" % str(state.all_fighters.map(func(f): return f.position_x)))
	state.turn_number += 1

	for fighter in state.all_fighters:
		fighter_logic.walk_forward(fighter)

	# --- Clash Detection ---
	var clash_distance = 50
	var team1_fighter = _get_rightmost_fighter(state.blue_fighters)
	var team2_fighter = _get_leftmost_fighter(state.red_fighters)

	if team1_fighter and team2_fighter:
		# Corrected clash detection logic
		if (team2_fighter.position_x - team1_fighter.position_x) < clash_distance:
			for f in state.blue_fighters:
				f.is_clashing = true
			for f in state.red_fighters:
				f.is_clashing = true

	# --- Clash Resolution ---
	if team1_fighter and team2_fighter and team1_fighter.is_clashing:
		_resolve_clash(team1_fighter, team2_fighter)


func _resolve_clash(fighter1: FighterState, fighter2: FighterState):
	if fighter1.pwr > fighter2.pwr:
		fighter2.position_x += 100  # Push back fighter2
		fighter1.position_x -= 100  # Push back fighter1
	elif fighter2.power > fighter1.power:
		fighter1.position_x -= 100  # Push back fighter1
	else:
		print("Clash is a draw!")
	fighter1.is_clashing = false
	fighter2.is_clashing = false


func _get_rightmost_fighter(fighters: Array[FighterState]) -> FighterState:
	var rightmost_fighter: FighterState = null
	for f in fighters:
		if not rightmost_fighter or f.position_x > rightmost_fighter.position_x:
			rightmost_fighter = f
	return rightmost_fighter

func _get_leftmost_fighter(fighters: Array[FighterState]) -> FighterState:
	var leftmost_fighter: FighterState = null
	for f in fighters:
		if not leftmost_fighter or f.position_x < leftmost_fighter.position_x:
			leftmost_fighter = f
	return leftmost_fighter
