extends Node

@onready var view = %View as BattleView
@onready var simulator = %Simulator as BattleSimulator
@onready var turn_timer = %TurnTimer as TurnTimer
@onready var state = %State as BattleState
@onready var input = %Input as InputHandler

func _ready():
	EventBus.subscribe_many(["battle_started"], [view, turn_timer])
	EventBus.subscribe_many(["1_released", "2_released", "3_released", "4_released"], [self])
	
	var fighter_id_counter = 0
	# 2. Populate Fighters for Team 1
	var initial_y_team1 = 315
	for i in range(4):
		var fighter_state = FighterState.new()
		fighter_state.team_id = 1
		fighter_state.id = fighter_id_counter
		fighter_state.pwr = 20
		fighter_id_counter += 1
		fighter_state.position_x = 480
		fighter_state.position_y = initial_y_team1 + (i * 60)
		state.blue_fighters.append(fighter_state)
		state.all_fighters.append(fighter_state)

	# 3. Populate Fighters for Team 2
	var initial_y_team2 = 315
	for i in range(4):
		var fighter_state = FighterState.new()
		fighter_state.team_id = -1
		fighter_state.id = fighter_id_counter
		fighter_state.pwr = 10
		fighter_id_counter += 1
		fighter_state.position_x = 1440
		fighter_state.position_y = initial_y_team2 + (i * 60)
		state.red_fighters.append(fighter_state)
		state.all_fighters.append(fighter_state)

	Log.entry("BattleInstance Ready. Initial logic state created.")
	EventBus.emit("battle_started")


func on_1_released(): turn_timer.set_game_speed(0)
func on_2_released(): turn_timer.set_game_speed(0.5)
func on_3_released(): turn_timer.set_game_speed(1)
func on_4_released(): turn_timer.set_game_speed(4)
