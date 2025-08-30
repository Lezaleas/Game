extends Node

@onready var view = %View as BattleView
@onready var simulator = %Simulator as BattleSimulator
@onready var turn_timer = %TurnTimer as TurnTimer
@onready var input = %InputHandler as InputHandler

func _ready():
	EventBus.subscribe_many(["battle_started"], [view, turn_timer])
	EventBus.subscribe_many(["1_released", "2_released", "3_released", "4_released"], [self])

	Situation.new_state()

	Log.entry("BattleInstance Ready. Initial logic state created.")
	EventBus.emit("battle_started")
	
	# TODO make sure to delete
	var dummy = Situation.fighters[0]
	Situation.skills.add_skill(preload("res://State/Events/new_resource.tres"))
	Situation.reservoirs[0].gain_mana(10)
	

func on_1_released(): turn_timer.set_game_speed(0.0)
func on_2_released(): turn_timer.set_game_speed(0.5)
func on_3_released(): turn_timer.set_game_speed(1.0)
func on_4_released(): turn_timer.set_game_speed(4.0)
