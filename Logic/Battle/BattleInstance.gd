extends Node

@onready var view = %View as BattleView
@onready var simulator = %Simulator as BattleSimulator
@onready var turn_timer = %TurnTimer as TurnTimer
@onready var input = %InputHandler as InputHandler

func _ready():
	EventBus.subscribe_many(["battle_started"], [view, turn_timer])
	EventBus.subscribe_many(["1_released", "2_released", "3_released", "4_released"], [self])

	Situation.new_state()
	Situation.attack_handler = %AttackHandler

	Log.entry("BattleInstance Ready. Initial logic state created.")
	
	# Load skills from intermission data
	for i in range(4):
		var player_fighter_state = Situation.fighters[i]
		var player_data = Situation.player_team_data[i]
		for skill in player_data.skills:
			if skill:
				Situation.skills.add_skill(player_fighter_state, skill)
				
		var enemy_fighter_state = Situation.fighters[i + 4]
		var enemy_data = Situation.enemy_team_data[i]
		for skill in enemy_data.skills:
			if skill:
				Situation.skills.add_skill(enemy_fighter_state, skill)

	EventBus.emit("battle_started")
	
	for fighter in Situation.fighters:
		fighter.attributes[0].increase_mult((fighter.id - fighter.parent.id * 4) / 10.0)
		fighter.position_x += 50 * fighter.id
	
	Situation.reservoirs[0].gain_mana(10)

func on_1_released(): turn_timer.set_game_speed(0.0)
func on_2_released(): turn_timer.set_game_speed(0.2)
func on_3_released(): turn_timer.set_game_speed(1.0)
func on_4_released(): turn_timer.set_game_speed(5.0)
