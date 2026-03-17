extends Resource
class_name BuffsState

var owner: FighterState
var buffs: Dictionary[Defines.BUFF, BuffState] = {}

func _init(_owner: FighterState) -> void:
	owner = _owner

func apply_buff(buff_data: Buff, amount: float, applier: FighterState = null) -> void:
	var id = buff_data.id
	#region Buff Event
	var buff_event = CmdApplyBuff.new(applier, owner, id, amount)
	buff_event = Situation.skills.resolve(buff_event)
	if buff_event.is_cancelled: return
	amount = buff_event.amount
	#endregion
	if not buffs.has(id):
		buffs[id] = BuffState.new(buff_data, owner)
	
	if buffs[id].add_amount(amount, applier):
		Log.entry("%s applied/triggered on %s" % [buff_data.display_name, owner])

func tick_all() -> void:
	for id in buffs:
		buffs[id].tick()

func get_buff_state(id: Defines.BUFF) -> BuffState:
	return buffs.get(id)

func _to_string() -> String:
	return "Buffs: " + str(buffs)
