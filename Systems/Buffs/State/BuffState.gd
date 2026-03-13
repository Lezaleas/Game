extends Resource
class_name BuffState

var data: Buff
var parent: FighterState

var progress: float = 0.0
var stacks: int = 0
var remaining_turns: int = 0

func _init(_data: Buff, _parent: FighterState) -> void:
	data = _data
	parent = _parent

func add_amount(amount: float) -> bool:
	# returns true if the buff triggers/refreshes
	if data.apply_immediately:
		stacks += int(amount)
		remaining_turns = data.duration_turns
		return true
	
	progress += amount
	if progress >= data.trigger_threshold:
		progress -= data.trigger_threshold
		remaining_turns = data.duration_turns
		return true
		
	return false

func tick() -> void:
	if remaining_turns > 0:
		remaining_turns -= 1
		if remaining_turns == 0:
			clear()

func clear() -> void:
	progress = 0.0
	stacks = 0
	remaining_turns = 0

func is_active() -> bool:
	return remaining_turns > 0

func _to_string() -> String:
	return "%s (%s/100, S:%s, T:%s)" % [data.display_name, progress, stacks, remaining_turns]
