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

	# Fighter movement is now handled by FighterLogic, which will emit events
	for fighter in state.all_fighters:
		fighter_logic.walk_forward(fighter)

	# --- Clash Detection ---
	var clash_distance = 50
	var team1_fighter = _get_rightmost_fighter(state.blue_fighters)
	var team2_fighter = _get_leftmost_fighter(state.red_fighters)

	if team1_fighter and team2_fighter:
		if (team2_fighter.position_x - team1_fighter.position_x) < clash_distance:
			# Create ClashEvent
			var clash_event = ClashEvent.new()
			clash_event.is_cancellable = true
			clash_event.fighter1 = team1_fighter
			clash_event.fighter2 = team2_fighter

			# Emit clash_detected event
			EventBus.emit("clash_detected", clash_event)

			if not clash_event.is_cancelled:
				for f in state.blue_fighters:
					f.is_clashing = true
				for f in state.red_fighters:
					f.is_clashing = true
				_resolve_clash(clash_event) # Pass the event to resolution
			else:
				Log.entry("Clash cancelled by passive skill.")
				# Reset clashing state if clash was cancelled
				for f in state.blue_fighters:
					f.is_clashing = false
				for f in state.red_fighters:
					f.is_clashing = false


func _resolve_clash(clash_event: ClashEvent):
	var fighter1 = clash_event.fighter1
	var fighter2 = clash_event.fighter2

	if fighter1.pwr > fighter2.pwr:
		clash_event.winner = fighter1
		clash_event.loser = fighter2
		clash_event.push_amount = 100
	elif fighter2.pwr > fighter1.pwr: # Corrected from fighter2.power
		clash_event.winner = fighter2
		clash_event.loser = fighter1
		clash_event.push_amount = 100
	else:
		clash_event.winner = null # Draw
		clash_event.loser = null
		clash_event.push_amount = 0
		print("Clash is a draw!")

	# Apply push based on event data
	if clash_event.loser:
		clash_event.loser.position_x += clash_event.push_amount * clash_event.loser.team_id
	if clash_event.winner:
		clash_event.winner.position_x -= clash_event.push_amount * clash_event.winner.team_id

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
