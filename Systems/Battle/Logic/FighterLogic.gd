extends Node
class_name FighterLogic

func walk_forward(fighter: FighterState) -> void:
	if fighter.clashed: return
	var distance = fighter.attributes[Defines.ATTRIBUTE.Agi].current * fighter.parent.direction * Defines.MOVE_SPEED as float
	#region Walk Event
	var cmd_walk = CmdWalk.new(fighter, distance)
	cmd_walk = Situation.skills.resolve(cmd_walk)
	if cmd_walk.is_cancelled: return
	distance = cmd_walk.distance
	#endregion
	if fighter.buffs.get_buff_state(Defines.BUFF.Freeze):
		distance /= 2
	fighter.position_x += distance

func process_turn(fighter: FighterState) -> void:
	fighter.gain_stamina(Defines.STAMINA_GAIN_TURN)
	fighter.clashed = false
