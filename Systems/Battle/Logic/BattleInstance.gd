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
	Situation.battle.battle_type = Situation.level_data.battle_type
	turn_timer.set_game_speed(1.0)
	
	# Load informaiton from the run heroes and apply them to the in combat fighters
	for x in range(Situation.player_team_data.size()):
		Utils.HeroToFighter(Situation.player_team_data[x], Situation.fighters[x])
	for x in range(4, 8):
		match x:
			4:
				Utils.EnemyToFighter(Situation.level_data.enemy0, Situation.fighters[x])
			5:
				Utils.EnemyToFighter(Situation.level_data.enemy1, Situation.fighters[x])
			6:
				Utils.EnemyToFighter(Situation.level_data.enemy2, Situation.fighters[x])
			7:
				Utils.EnemyToFighter(Situation.level_data.enemy3, Situation.fighters[x])
	
	# Load skills from intermission data
	for fighter in Situation.fighters:
		if fighter.skills:
			for skill in fighter.skills:
				Situation.skills.add_skill(fighter, skill)
				
	#Log.entry("BattleInstance Ready. Initial logic state created.")
	EventBus.emit("battle_started")

func on_1_released(): turn_timer.set_game_speed(0.0)
func on_2_released(): turn_timer.set_game_speed(0.2)
func on_3_released(): turn_timer.set_game_speed(1.0)
func on_4_released(): turn_timer.set_game_speed(5.0)
