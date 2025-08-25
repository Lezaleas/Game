extends Node
class_name CancelMovementSkill

var fighter_id_to_cancel: int = 0

func _ready():
	EventBus.subscribe("fighter_moving", self, "on_fighter_moving", 100) # High priority

func on_fighter_moving(event: FighterMoveEvent):
	if event.fighter.id == fighter_id_to_cancel:
		Log.entry("Passive Skill: Cancelling movement for fighter %d!" % event.fighter.id)
		event.is_cancelled = true
