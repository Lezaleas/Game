class_name EquipmentSwapHandler
extends Node

var selected_slot: EquipmentSlot = null

@onready var selection_screen: EquipmentSelection = get_parent()

func _ready() -> void:
	EventBus.subscribe("equipment_slot_clicked", self, "on_slot_clicked")
	EventBus.subscribe("equipment_slot_right_clicked", self, "on_slot_right_clicked")

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
	var hero_a = _get_hero_from_slot(a)
	var hero_b = _get_hero_from_slot(b)
	
	# Case 1: Swapping within inventory (both no restriction)
	if a.equip_type_restriction == -1 and b.equip_type_restriction == -1:
		return true
		
	# Case 2: From inventory to hero slot
	if a.equip_type_restriction == -1 and b.equip_type_restriction != -1:
		var type_match = a.equipment and a.equipment.type == b.equip_type_restriction
		if not type_match: return false
		
		var weight_diff = a.equipment.weight - (b.equipment.weight if b.equipment else 0)
		if hero_b.weight + weight_diff > Defines.MAX_WEIGHT:
			print("Too heavy! Max weight is ", Defines.MAX_WEIGHT)
			return false
		return true
		
	# Case 3: From hero slot to inventory
	if a.equip_type_restriction != -1 and b.equip_type_restriction == -1:
		return true # Can always move back to inventory
		
	# Case 4: Swapping between hero slots
	if a.equip_type_restriction != -1 and b.equip_type_restriction != -1:
		var can_a_go_to_b = (not a.equipment) or (a.equipment.type == b.equip_type_restriction)
		var can_b_go_to_a = (not b.equipment) or (b.equipment.type == a.equip_type_restriction)
		if not (can_a_go_to_b and can_b_go_to_a): return false
		
		if hero_a == hero_b: return true
		
		var weight_gain_a = (b.equipment.weight if b.equipment else 0) - (a.equipment.weight if a.equipment else 0)
		var weight_gain_b = (a.equipment.weight if a.equipment else 0) - (b.equipment.weight if b.equipment else 0)
		
		if (hero_a.weight + weight_gain_a > Defines.MAX_WEIGHT) or (hero_b.weight + weight_gain_b > Defines.MAX_WEIGHT):
			print("Weight limit reached for one of the heroes!")
			return false
		return true
		
	return false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_clear_selection()

func on_slot_right_clicked(slot: EquipmentSlot) -> void:
	if not slot or not slot.equipment:
		return
	var item = slot.equipment
	var hero = _get_hero_from_slot(slot)
	if hero:
		hero.unequip(slot.equip_type_restriction)
	if RunManager.equipment.has(item):
		RunManager.equipment.erase(item)
	print("Right-click discarded: ", item.display_name)
	if selection_screen:
		selection_screen.refresh()
