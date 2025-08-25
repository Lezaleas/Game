extends Node
class_name FighterLogic

func walk_forward(fighter: FighterState) -> void:
	var old_position_x = fighter.position_x
	var new_position_x = fighter.position_x + fighter.agi * fighter.team_id * GameRules.MOVE_SPEED

	var move_event = FighterMoveEvent.new()
	move_event.is_cancellable = true
	move_event.fighter = fighter
	move_event.original_position_x = old_position_x
	move_event.new_position_x = new_position_x

	EventBus.emit("fighter_moving", move_event)

	if not move_event.is_cancelled:
		fighter.position_x = move_event.new_position_x
	else:
		Log.entry("Fighter %d movement cancelled by passive skill." % fighter.id)
