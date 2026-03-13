extends Buff
class_name BurnBuff

func _init() -> void:
	id = "burn"
	display_name = "Burn"
	is_debuff = true
	trigger_threshold = 100.0
	duration_turns = 3
	apply_immediately = false
