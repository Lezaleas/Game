extends Resource
class_name Buff

@export var id: Defines.BUFF
@export var display_name: String
@export var icon: Texture2D
@export var is_debuff: bool = true
@export var trigger_threshold: float = 100.0
@export var duration_turns: int = 3
@export var apply_immediately: bool = false # False: progress logic. True: stack logic.

func _to_string() -> String:
	return display_name
