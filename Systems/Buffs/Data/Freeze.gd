extends Buff
class_name FreezeBuff

func _init() -> void:
	id = "freeze"
	display_name = "Freeze"
	is_debuff = true
	trigger_threshold = 100.0
	duration_turns = 1
	apply_immediately = false
