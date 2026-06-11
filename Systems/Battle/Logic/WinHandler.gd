extends Node
class_name WinHandler

func _ready() -> void:
	EventBus.subscribe("capture_requested", self, "on_capture_requested")

func check_win_condition():
	for fighter in Situation.fighters:
		# Blue Team (Left) wins if > 75% (Right Side)
		if fighter.parent.id == 0: # Blue Team
			if fighter.position_x >= Defines.WIN_TRESHOLD_BLUE:
				_trigger_win(0)
				
		# Red Team (Right) wins if < 25% (Left Side)
		elif fighter.parent.id == 1: # Red Team
			if fighter.position_x <= Defines.WIN_TRESHOLD_RED:
				_trigger_win(1)

func _trigger_win(team_id: int) -> void:
	#Log.entry("Battle Ended! Team %d Wins!" % team_id)
	Situation.turn_timer.stop()
	EventBus.emit("battle_won", team_id)
	if team_id == 1:
		_finish_battle(team_id)

func _finish_battle(team_id: int) -> void:
	if Situation.battle.battle_type == BattleState.BattleType.ARENA: return
	if team_id == 0 and Situation.level_data:
		Situation.level_data.cleared = true

		for reward in Situation.level_data.rewards:
			if reward:
				reward.apply_reward()

	Situation.clear_state_generic()
	get_tree().change_scene_to_file("res://Systems/Run/Logic/RunScene.tscn")
	
func on_capture_requested(fighter_id: int) -> void:
	_capture_fighter(fighter_id)
	_finish_battle(0)
	
func _capture_fighter(fighter_id:int) -> void:
	var enemy: EnemyData = Situation.fighters[fighter_id].enemy_data
	var critter: = Critter.new()
	critter.ConvertFromEnemy(enemy)
	RunManager.critters.append(critter)
