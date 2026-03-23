class_name EquipmentSwapHandler
extends Node

var selected_slot: EquipmentSlot = null

@onready var selection_screen: EquipmentSelection = get_parent()

func _ready() -> void:
	EventBus.subscribe("equipment_slot_clicked", self, "on_slot_clicked")

func on_slot_clicked(slot: EquipmentSlot) -> void:
	if selected_slot == null:
		if slot.equipment:
			_select(slot)
		return
		
	if slot == selected_slot:
		_clear_selection()
		return
		
	if _can_swap(selected_slot, slot):
		_swap(selected_slot, slot)
		_clear_selection()
	else:
		# If we click another item in inventory, switch selection
		if slot.equipment and slot.equip_type_restriction == -1:
			_select(slot)
		else:
			_clear_selection()

func _select(slot: EquipmentSlot) -> void:
	if selected_slot:
		selected_slot.set_selected(false)
	selected_slot = slot
	selected_slot.set_selected(true)
	print("Selected equipment: ", slot.equipment.display_name if slot.equipment else "None")

func _clear_selection() -> void:
	if selected_slot:
		selected_slot.set_selected(false)
	selected_slot = null

func _swap(a: EquipmentSlot, b: EquipmentSlot) -> void:
	var hero_a: HeroState = _get_hero_from_slot(a)
	var hero_b: HeroState = _get_hero_from_slot(b)
	
	var item_a = a.equipment
	var item_b = b.equipment
	
	# Perform swap logic
	if hero_a:
		if item_b: hero_a.equip(item_b)
		else: hero_a.unequip(a.equip_type_restriction)
	
	if hero_b:
		if item_a: hero_b.equip(item_a)
		else: hero_b.unequip(b.equip_type_restriction)
	
	# For inventory-to-inventory swaps, we might want to reorder RunManager.equipment
	# But since it's filtered, it's easier to just ignore internal inventory reordering for now
	# and just refresh the whole view.
	
	# Refresh UI through parent
	if selection_screen:
		selection_screen.refresh()
	
	print("Swapped equipment and refreshed UI")

func _get_hero_from_slot(slot: EquipmentSlot) -> HeroState:
	# We can find the hero by looking at the parent HeroEquipmentPanel
	var p = slot.get_parent()
	while p:
		if p is HeroEquipmentPanel:
			return p.hero
		p = p.get_parent()
	return null

func _persist_slot_change(slot: EquipmentSlot) -> void:
	if slot.index < 0: return
	
	if slot.index >= slot.source_array.size():
		slot.source_array.resize(slot.index + 1)
	
	slot.source_array[slot.index] = slot.equipment

func _can_swap(a: EquipmentSlot, b: EquipmentSlot) -> bool:
	# Case 1: Swapping within inventory (both no restriction)
	if a.equip_type_restriction == -1 and b.equip_type_restriction == -1:
		return true
		
	# Case 2: From inventory to hero slot
	if a.equip_type_restriction == -1 and b.equip_type_restriction != -1:
		return a.equipment and a.equipment.type == b.equip_type_restriction
		
	# Case 3: From hero slot to inventory
	if a.equip_type_restriction != -1 and b.equip_type_restriction == -1:
		return true # Can always move back to inventory
		
	# Case 4: Swapping between hero slots (probably not needed but for completeness)
	if a.equip_type_restriction != -1 and b.equip_type_restriction != -1:
		var can_a_go_to_b = (not a.equipment) or (a.equipment.type == b.equip_type_restriction)
		var can_b_go_to_a = (not b.equipment) or (b.equipment.type == a.equip_type_restriction)
		return can_a_go_to_b and can_b_go_to_a
		
	return false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_clear_selection()
