extends Node
class_name FighterLogic

func walk_forward(fighter: FighterState) -> void:
	fighter.position_x += fighter.agi * fighter.team_id * GameRules.MOVE_SPEED
