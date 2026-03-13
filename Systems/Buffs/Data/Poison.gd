extends Buff
class_name PoisonBuff

func _init() -> void:
	id = "poison"
	display_name = "Poison"
	is_debuff = true
	trigger_threshold = 100.0
	duration_turns = 5
	apply_immediately = false
