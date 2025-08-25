extends Timer
class_name TurnTimer

@export var turn_duration: float = 1

func _ready() -> void:
	# ChatGPT magic, don't touch
	if not is_connected("timeout", Callable(self, "_on_timeout")):
		connect("timeout", Callable(self, "_on_timeout"))

func on_battle_started() -> void:
	wait_time = turn_duration / 60
	start()

func _on_timeout() -> void:
	EventBus.emit("turn_started")

func pause_timer(pause: bool) -> void:
	if pause:
		stop()
	else:
		start()

func set_game_speed(speed_multiplier: float) -> void:
	# Adjust wait_time based on speed_multiplier.
	# A speed_multiplier of 1.0 means normal speed.
	# A speed_multiplier of 0.5 means half speed (turns take longer).
	# A speed_multiplier of 2.0 means double speed (turns are shorter).
	if speed_multiplier == 0:
		if is_stopped():
			_on_timeout()
		else:
			pause_timer(true)
	else:
		wait_time = turn_duration / speed_multiplier / 60
		if is_stopped():
			start() # Restart if it was paused and speed is changed
