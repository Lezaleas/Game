extends Buff
class_name ShockBuff

func _init() -> void:
	id = "shock"
	display_name = "Shock"
	is_debuff = true
	trigger_threshold = 100.0
	duration_turns = 2
	apply_immediately = false
