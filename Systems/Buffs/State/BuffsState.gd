extends Resource
class_name BuffsState

var owner: FighterState
var buffs: Dictionary[String, BuffState] = {}

func _init(_owner: FighterState) -> void:
	owner = _owner

func apply_buff(buff_data: Buff, amount: float) -> void:
	var id = buff_data.id
	if not buffs.has(id):
		buffs[id] = BuffState.new(buff_data, owner)
	
	if buffs[id].add_amount(amount):
		Log.entry("%s applied/triggered on %s" % [buff_data.display_name, owner])

func tick_all() -> void:
	for id in buffs:
		buffs[id].tick()

func get_buff_state(id: String) -> BuffState:
	return buffs.get(id)

func _to_string() -> String:
	return "Buffs: " + str(buffs)
