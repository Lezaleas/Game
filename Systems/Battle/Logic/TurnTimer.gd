extends Timer
class_name TurnTimer

@export var turn_duration: float = 0.2
var manual_turns: = false

func on_battle_started() -> void:
	EventBus.subscribe("request_pause", self, "pause_timer")
	connect("timeout", Callable(self, "_on_timeout"))
	wait_time = turn_duration
	start()
	Situation.turn_timer = self

func _on_timeout() -> void:
	EventBus.emit("turn_started")

func pause_timer(pause: bool) -> void:
	if pause:
		stop()
	else:
		if manual_turns: return
		start()

func set_game_speed(speed_multiplier: float) -> void:
	# Adjust wait_time based on speed_multiplier.
	# A speed_multiplier of 1.0 means normal speed.
	# A speed_multiplier of 0.5 means half speed (turns take longer).
	# A speed_multiplier of 2.0 means double speed (turns are shorter).
	if speed_multiplier == 0:
		manual_turns = true
		if is_stopped():
			_on_timeout()
		else:
			stop()
	else:
		manual_turns = false
		Situation.anim_speed = speed_multiplier
		wait_time = turn_duration / speed_multiplier
		if is_stopped():
			start() # Restart if it was paused and speed is changed
	EventBus.emit("game_speed_changed", speed_multiplier)
