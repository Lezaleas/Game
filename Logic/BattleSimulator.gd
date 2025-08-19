extends Node
class_name BattleSimulator

# Processes a single turn of the battle, returning a new state.
func process_turn(current_state: BattleState) -> BattleState:
	var next_state = BattleState.new()
	next_state.turn_number = current_state.turn_number + 1

	# Manually duplicate fighters to ensure a deep copy
	for fighter_in in current_state.team1_fighters:
		var fighter_out = fighter_in.duplicate()
		next_state.team1_fighters.append(fighter_out)

	for fighter_in in current_state.team2_fighters:
		var fighter_out = fighter_in.duplicate()
		next_state.team2_fighters.append(fighter_out)

	# --- Apply logic to the new state ---

	# --- Clash Detection ---
	var clash_distance = 50
	var team1_fighter = _get_rightmost_fighter(next_state.team1_fighters)
	var team2_fighter = _get_leftmost_fighter(next_state.team2_fighters)

	if team1_fighter and team2_fighter:
		# Corrected clash detection logic
		if (team2_fighter.position_x - team1_fighter.position_x) < clash_distance:
			for f in next_state.team1_fighters:
				f.is_clashing = true
			for f in next_state.team2_fighters:
				f.is_clashing = true
			print("Clash detected!")

	# --- Movement ---
	# Move Team 1 (left team, moves right)
	for fighter in next_state.team1_fighters:
		if not fighter.is_clashing:
			assert(fighter is FighterState)
			fighter.position_x += fighter.speed

	# Move Team 2 (right team, moves left)
	for fighter in next_state.team2_fighters:
		if not fighter.is_clashing:
			assert(fighter is FighterState)
			fighter.position_x -= fighter.speed

	# --- Clash Resolution ---
	if team1_fighter and team2_fighter and team1_fighter.is_clashing:
		_resolve_clash(team1_fighter, team2_fighter)

	return next_state


func _resolve_clash(fighter1: FighterState, fighter2: FighterState):
	print("Resolving clash...")
	if fighter1.power > fighter2.power:
		fighter2.position_x += 10  # Push back fighter2
		print("Fighter 1 wins the clash!")
	elif fighter2.power > fighter1.power:
		fighter1.position_x -= 10  # Push back fighter1
		print("Fighter 2 wins the clash!")
	else:
		print("Clash is a draw!")


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
