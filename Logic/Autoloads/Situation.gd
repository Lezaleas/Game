extends Node

var battle: BattleState
var skills: SkillsState
var teams: Array[TeamState]
var fighters: Array[FighterState]
var reservoirs: Array[ReservoirState]
var attributes: Array[AttributeState]

func new_state():
	battle = BattleState.new()
	skills = SkillsState.new()
	for _a in range(2):
		var team = _new_state_unit(TeamState, battle, teams, battle.teams)
		for _b in range(4):
			var fighter = _new_state_unit(FighterState, team, fighters, team.fighters)
			for _c in range(4):
				var _attribute = _new_state_unit(AttributeState, fighter, attributes, fighter.attributes)
		for _d in range(4):
			var _reservoir = _new_state_unit(ReservoirState, team, reservoirs, team.reservoirs)

func _new_state_unit(type:GDScript, parent:Resource, directory_list:Array, parent_list:Array):
	var state_unit = type.new()
	state_unit.id = len(directory_list)
	state_unit.parent = parent
	if state_unit.has_method("setup"): state_unit.setup()
	parent_list.append(state_unit)
	directory_list.append(state_unit)
	return state_unit

func clear_state_generic():
	# Iterate over all properties on this autoload
	for prop in get_property_list():
		var name = prop.name
		var value = get(name)
		
		# Clear arrays
		if typeof(value) == TYPE_ARRAY:
			value.clear()
		
		# Nullify single Resource references
		elif typeof(value) == TYPE_OBJECT and value is Resource:
			set(name, null)
