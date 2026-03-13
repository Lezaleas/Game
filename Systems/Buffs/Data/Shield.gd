extends Buff
class_name ShieldBuff

func _init() -> void:
	id = "shield"
	display_name = "Shield"
	is_debuff = false
	apply_immediately = true
	duration_turns = 99 # Persistent until stacks gone? Or has duration? User said "apply x stacks at once"
