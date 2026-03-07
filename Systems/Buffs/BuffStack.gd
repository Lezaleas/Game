extends Resource
class_name BuffStack

@export var id: String
@export var duration: int = 100

var progress: float = 0.0
var remaining_duration: int = 0

func is_active() -> bool:
	return remaining_duration > 0

func add_progress(amount: float) -> bool:
	# returns true if the buff/debuff triggers this call
	progress += amount
	if progress >= 100.0:
		progress -= 100.0
		remaining_duration = duration
		return true
	return false

func tick_duration() -> void:
	if remaining_duration > 0:
		remaining_duration -= 1

func clear() -> void:
	progress = 0.0
	remaining_duration = 0
