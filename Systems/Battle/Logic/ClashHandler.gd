extends Node
class_name ClashHandler

@onready var attack_handler: AttackHandler = %AttackHandler

var blue_clasher: FighterState
var red_clasher: FighterState
var tiebreaker: = true

func process_clash():
	while _engage_range_detect():
		EventBus.emit("request_pause", true)
		_resolve_clash()
		await get_tree().create_timer(0.50 / Situation.anim_speed).timeout
		EventBus.emit("request_pause", false)

func _engage_range_detect():
	blue_clasher = Situation.teams[0].get_rightmost_fighter()
	red_clasher = Situation.teams[1].get_leftmost_fighter()
	if (red_clasher.position_x - blue_clasher.position_x) <= Defines.CLASH_ENGAGE_RANGE:
		blue_clasher.clashed = true
		red_clasher.clashed = true
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
	var blue_clashing_strength = (blue_clasher.attributes[Defines.ATTRIBUTE.Pwr].current + clash_event.blue_strength_bonus) * blue_clasher.stamina as float
	var red_clashing_strength = (red_clasher.attributes[Defines.ATTRIBUTE.Pwr].current + clash_event.red_strength_bonus) * red_clasher.stamina as float
	
	EventBus.emit("battle_action_clash_started", {
		"blue": blue_clasher,
		"red": red_clasher,
		"blue_str": blue_clashing_strength,
		"red_str": red_clashing_strength
	})
	
	_decide_winner(blue_clasher, red_clasher, blue_clashing_strength, red_clashing_strength)
	
func _decide_winner(_blue_clasher, _red_clasher, blue_strength: int, red_strength: int) -> void:
	var winner = null
	if blue_strength == red_strength:
		winner = blue_clasher if tiebreaker else red_clasher
		tiebreaker = not tiebreaker
	else:
		winner = blue_clasher if blue_strength > red_strength else red_clasher
	var loser = red_clasher if winner == blue_clasher else blue_clasher

	winner.clash_won += 1
	winner.gain_stamina(-Defines.STAMINA_LOSS_VICTORY)
	
	#region Clash Evasion ------------------------------------
	var evasion_event = CmdClashEvasion.new(blue_clasher, red_clasher)
	var loser_eva = loser.attributes[Defines.ATTRIBUTE.Eva].current
	var winner_acc = winner.attributes[Defines.ATTRIBUTE.Acc].current
	if randf() < (loser_eva - winner_acc) / 100.0:
		evasion_event.is_evaded = true
	
	evasion_event = Situation.skills.resolve(evasion_event)
	if evasion_event.is_evaded:
		winner.gain_stamina(-Defines.STAMINA_LOSS_VICTORY) # Lose double stamina
		return # Skip link attacks
	#endregion -----------------------------------------------
	
	#region Clash Crit ---------------------------------------
	var crit_event = CmdClashCrit.new(blue_clasher, red_clasher)
	var winner_crit = winner.attributes[Defines.ATTRIBUTE.Crit].current
	var loser_cdef = loser.attributes[Defines.ATTRIBUTE.Cdef].current
	if randf() < (winner_crit - loser_cdef) / 100.0:
		crit_event.is_critical = true
	
	crit_event = Situation.skills.resolve(crit_event)
	var crit_mult = 1.0
	if crit_event.is_critical:
		crit_mult = crit_event.critical_mult
	#endregion -----------------------------------------------

	_cast_link_attacks(winner, loser, crit_mult)
			
		
func _cast_link_attacks(clash_winner: FighterState, defender: FighterState, crit_mult: float = 1.0):
	var damage_mult = 1.0 * crit_mult as float
	var attackers = [] as Array[FighterState]
	for fighter in clash_winner.get_allied_team().fighters:
		if fighter == clash_winner: continue
		attackers.append(fighter)
	#region Clash Link Event
	var clash_link_event = CmdClashLink.new(clash_winner, attackers, defender, damage_mult)
	clash_link_event = Situation.skills.resolve(clash_link_event)
	if clash_link_event.is_cancelled: return
	attackers = clash_link_event.links
	defender = clash_link_event.loser
	damage_mult = clash_link_event.damage_mult
	#endregion
	for fighter in attackers:
		attack_handler.cast(fighter, 0, damage_mult, Defines.TARGETING_TYPE.Choose, defender)
