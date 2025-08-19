extends Node

var battle_state: BattleState
var battle_simulator: BattleSimulator
var fighter_id_counter = 0

const FighterScene = preload("res://Visuals/Scenes/FighterVisual.tscn")

func _ready():
	# 1. Initialize State and Simulator
	battle_state = BattleState.new()
	battle_simulator = BattleSimulator.new()

	# 2. Populate Fighters for Team 1
	var initial_y_team1 = 315
	for i in range(4):
		var fighter_state = FighterState.new()
		fighter_state.id = fighter_id_counter
		fighter_state.power = 20
		fighter_id_counter += 1
		fighter_state.position_x = 480
		fighter_state.position_y = initial_y_team1 + (i * 60)
		battle_state.team1_fighters.append(fighter_state)

		var fighter_scene = FighterScene.instantiate()
		fighter_scene.fighter_state = fighter_state
		add_child(fighter_scene)

	# 3. Populate Fighters for Team 2
	var initial_y_team2 = 315
	for i in range(4):
		var fighter_state = FighterState.new()
		fighter_state.id = fighter_id_counter
		fighter_state.power = 10
		fighter_id_counter += 1
		fighter_state.position_x = 1440
		fighter_state.position_y = initial_y_team2 + (i * 60)
		battle_state.team2_fighters.append(fighter_state)

		var fighter_scene = FighterScene.instantiate()
		fighter_scene.fighter_state = fighter_state
		add_child(fighter_scene)

	print("BattleInstance Ready. Initial state created.")
	print_fighter_positions()

func _process(_delta):
	# Run the simulation one step
	battle_state = battle_simulator.process_turn(battle_state)

	# Print state for debugging
	print("--- Turn: %d ---" % battle_state.turn_number)
	print_fighter_positions()

func print_fighter_positions():
	var team1_pos = battle_state.team1_fighters.map(func(f): return f.position_x)
	var team2_pos = battle_state.team2_fighters.map(func(f): return f.position_x)
	print("Team 1 Positions: %s" % str(team1_pos))
	print("Team 2 Positions: %s" % str(team2_pos))
