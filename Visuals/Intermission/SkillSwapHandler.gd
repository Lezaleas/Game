extends Node
class_name SkillSwapHandler

var selected_slot: SkillSlot = null

func _ready() -> void:
	EventBus.subscribe("slot_clicked", self, "on_slot_clicked")

func on_slot_clicked(slot: SkillSlot) -> void:
	if selected_slot == null:
		_select(slot)
		return
	if slot == selected_slot:
		_clear_selection()
		return
	if _can_swap(selected_slot, slot):
		_swap(selected_slot, slot)
	_clear_selection()

func _select(slot: SkillSlot) -> void:
	selected_slot = slot

func _clear_selection() -> void:
	if selected_slot:
		selected_slot.release_focus()
	selected_slot = null

func _swap(a: SkillSlot, b: SkillSlot) -> void:
	var temp := a.skill
	a.set_skill(b.skill)
	b.set_skill(temp)
	
	_persist_slot_change(a)
	_persist_slot_change(b)

func _persist_slot_change(slot: SkillSlot) -> void:
	if slot.index < 0: return
	
	if slot.index >= slot.source_array.size():
		slot.source_array.resize(slot.index + 1)
	
	slot.source_array[slot.index] = slot.skill

func _can_swap(_a: SkillSlot, _b: SkillSlot) -> bool:
	return true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_clear_selection()
