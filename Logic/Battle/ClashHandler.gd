extends Node
class_name ClashHandler

@onready var attack_handler: AttackHandler = %AttackHandler

var blue_clasher: FighterState
var red_clasher: FighterState

func process_clash():
	while _engage_range_detect():
		_resolve_clash()

func _engage_range_detect():
	blue_clasher = Situation.teams[0].get_rightmost_fighter()
	red_clasher = Situation.teams[1].get_leftmost_fighter()
	if (red_clasher.position_x - blue_clasher.position_x) <= Defines.CLASH_ENGAGE_RANGE:
		return true
	return false

func _resolve_clash():
	#region Clash Start Event
	var clash_event = CmdClashStart.new(blue_clasher, red_clasher)
	clash_event = Situation.skills.resolve(clash_event)
	if clash_event.is_cancelled: return
	blue_clasher = clash_event.blue_clasher
	red_clasher = clash_event.red_clasher
	#endregion
	blue_clasher.clash_fought += 1
	red_clasher.clash_fought += 1
	var blue_clashing_strength = blue_clasher.attributes[0].current * blue_clasher.stamina as float
	var red_clashing_strength = red_clasher.attributes[0].current * red_clasher.stamina as float
	if blue_clashing_strength > red_clashing_strength:
		blue_clasher.clash_won += 1
		_cast_link_attacks(blue_clasher, red_clasher)
	elif red_clashing_strength > blue_clashing_strength:
		red_clasher.clash_won += 1
		_cast_link_attacks(red_clasher, blue_clasher)
	else:
		_cast_link_attacks(blue_clasher, red_clasher)
		_cast_link_attacks(red_clasher, blue_clasher)
		
func _cast_link_attacks(clash_winner: FighterState, defender: FighterState):
	var damage_mult = 1.0 as float
	var attackers = [] as Array[FighterState]
	for fighter in clash_winner.get_allied_team().fighters:
		if fighter == clash_winner: continue
		attackers.append(fighter)
	#region Clash Link Event
	var clash_link_event = CmdClashLink.new(clash_winner, attackers, defender, damage_mult)
	clash_link_event = Situation.skills.resolve(clash_link_event)
	if clash_link_event.is_cancelled: return
	attackers = clash_link_event.attackers
	defender = clash_link_event.defender
	damage_mult = clash_link_event.damage_mult
	#endregion
	for fighter in attackers:
		attack_handler.cast(fighter, 0, damage_mult, Defines.TARGETING_TYPE.Choose, defender)
