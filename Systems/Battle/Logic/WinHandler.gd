extends Node
class_name WinHandler

func check_win_condition():
	for fighter in Situation.fighters:
		# Blue Team (Left) wins if > 75% (Right Side)
		if fighter.parent.id == 0: # Blue Team
			if fighter.position_x >= Defines.RIGHT_BOUNDARY * (1.0 - Defines.WIN_THRESHOLD_RATIO):
				_trigger_win(0)
				
		# Red Team (Right) wins if < 25% (Left Side)
		elif fighter.parent.id == 1: # Red Team
			if fighter.position_x <= Defines.LEFT_BOUNDARY * Defines.WIN_THRESHOLD_RATIO:
				_trigger_win(1)

func _trigger_win(team_id: int):
	# Using current log for now, can be expanded to UI
	Log.entry("Battle Ended! Team %d Wins!" % team_id)
	get_tree().change_scene_to_file("res://Systems/Run/Logic/RunScene.tscn")
	Situation.clear_state_generic()
	EventBus.emit("battle_won", team_id)
