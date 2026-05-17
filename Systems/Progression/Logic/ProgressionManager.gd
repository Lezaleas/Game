extends Node
# ProgressionManager
# Handles the logic for the Progression System (Buildings, Rooms, Villagers).

var buildings: Array[Building] = []
var villagers: Array[Villager] = []
var reserve_villagers: Array[Villager] = []

func _ready() -> void:
	# Initial setup (this might be handled by RunManager in the future)
	if buildings.is_empty():
		_setup_debug_data()

func _setup_debug_data() -> void:
	# Create Forge
	var forge = Building.new()
	forge.building_name = "Iron Forge"
	forge.specialization = Defines.EQUIP_TYPE.Sword
	
	var anvil_room = Room.new()
	anvil_room.room_name = "Anvil Area"
	anvil_room.element = Defines.PROG_ELEMENT.Fire
	
	forge.rooms.append(anvil_room)
	buildings.append(forge)
	
	# Create Atelier
	var atelier = Building.new()
	atelier.building_name = "Mystic Atelier"
	atelier.specialization = Defines.EQUIP_TYPE.Staff
	
	var altar_room = Room.new()
	altar_room.room_name = "Ritual Altar"
	altar_room.element = Defines.PROG_ELEMENT.Water
	
	atelier.rooms.append(altar_room)
	buildings.append(atelier)
	
	# Create some villagers in reserve
	var v1 = Villager.new()
	v1.name = "Buliwyf"
	v1.tags = {Defines.PROG_TAG.Smithing: 8, Defines.PROG_TAG.Crafting: 4}
	v1.modifiers.append(HeavyArmorModifier.new())
	
	var v2 = Villager.new()
	v2.name = "Eir"
	v2.tags = {Defines.PROG_TAG.Arcane: 7, Defines.PROG_TAG.Learning: 5}
	v2.traits.append(PreciseSmithingModifier.new())
	
	var v3 = Villager.new()
	v3.name = "Gunnar"
	v3.tags = {Defines.PROG_TAG.Charisma: 6, Defines.PROG_TAG.Warfare: 3}
	v3.modifiers.append(WeightTransformationModifier.new())
	
	reserve_villagers.append_array([v1, v2, v3])

# Calculate total tag pressure for all buildings
func get_global_tag_pressure() -> Dictionary:
	var global_pressure = {}
	for building in buildings:
		var building_pressure = building.get_tag_pressure()
		for tag in building_pressure:
			if not global_pressure.has(tag):
				global_pressure[tag] = 0
			global_pressure[tag] += building_pressure[tag]
	return global_pressure

# Get pressure for a specific building
func get_building_pressure(building_name: String) -> Dictionary:
	for building in buildings:
		if building.building_name == building_name:
			return building.get_tag_pressure()
	return {}

# Advance the week (Weekly Loop logic)
func advance_week() -> void:
	print("Advancing progression week...")
	var pressure = get_global_tag_pressure()
	# ... implementation of week advancement ...
	print("Tag pressure at end of week: ", pressure)

# Runs the full 10-step item generation pipeline for a given building.
func generate_item_via_pipeline(building: Building, global_modifiers: Array[Modifier] = []) -> EquipmentState:
	# 1. Create GenerationContext
	var context = GenerationContext.new()
	context.building = building
	context.global_modifiers = global_modifiers
	
	var all_villagers: Array[Villager] = []
	for r in building.rooms:
		if r:
			all_villagers.append_array(r.assigned_villagers)
	context.villagers = all_villagers

	# 2. Calculate building tag pressure
	context.tags = building.get_tag_pressure().duplicate()

	# 3. Collect active modifiers across all rooms and villagers
	var modifiers: Array[Modifier] = []
	modifiers.append_array(global_modifiers)
	for r in building.rooms:
		if not r: continue
		modifiers.append_array(r.modifiers)
		for v in r.assigned_villagers:
			if not v: continue
			modifiers.append_array(v.modifiers)
			modifiers.append_array(v.traits)
			
	# Sort modifiers by priority (highest priority first)
	modifiers.sort_custom(func(a, b): return a.priority > b.priority)

	# 4. Execute CALCULATE_TAG_PRESSURE hooks
	_execute_hook(Defines.ModifierHook.CALCULATE_TAG_PRESSURE, context, modifiers)

	# 5. Generate item category weights
	for type in Defines.EQUIP_TYPE.values():
		if type == building.specialization:
			context.item_weights[type] = 50.0 # Bias towards building specialization
		else:
			context.item_weights[type] = 10.0

	# Tag pressures influence base category weights
	var smith = context.tags.get(Defines.PROG_TAG.Smithing, 0.0)
	var war = context.tags.get(Defines.PROG_TAG.Warfare, 0.0)
	var arc = context.tags.get(Defines.PROG_TAG.Arcane, 0.0)
	var learn = context.tags.get(Defines.PROG_TAG.Learning, 0.0)
	var craft = context.tags.get(Defines.PROG_TAG.Crafting, 0.0)
	var steward = context.tags.get(Defines.PROG_TAG.Stewardry, 0.0)
	var charis = context.tags.get(Defines.PROG_TAG.Charisma, 0.0)
	var wild = context.tags.get(Defines.PROG_TAG.Wildcraft, 0.0)

	context.item_weights[Defines.EQUIP_TYPE.Sword] = context.item_weights.get(Defines.EQUIP_TYPE.Sword, 0.0) + smith * 1.5 + war * 1.0 + wild * 0.5
	context.item_weights[Defines.EQUIP_TYPE.Staff] = context.item_weights.get(Defines.EQUIP_TYPE.Staff, 0.0) + arc * 2.0 + learn * 1.0 + charis * 1.0
	context.item_weights[Defines.EQUIP_TYPE.Armor] = context.item_weights.get(Defines.EQUIP_TYPE.Armor, 0.0) + craft * 1.5 + smith * 1.0 + steward * 1.0
	context.item_weights[Defines.EQUIP_TYPE.Boots] = context.item_weights.get(Defines.EQUIP_TYPE.Boots, 0.0) + wild * 1.5 + steward * 1.0 + war * 0.5

	# 6. Execute CALCULATE_ITEM_WEIGHTS hooks
	_execute_hook(Defines.ModifierHook.CALCULATE_ITEM_WEIGHTS, context, modifiers)

	# 7. Roll item base
	var chosen_type = _roll_weighted(context.item_weights)
	
	# Determine quality level based on building quality
	var q_val = building.quality
	context.quality = Defines.EQUIP_QUALITY.Common
	if q_val >= 75.0:
		context.quality = Defines.EQUIP_QUALITY.Legendary
	elif q_val >= 50.0:
		context.quality = Defines.EQUIP_QUALITY.Epic
	elif q_val >= 25.0:
		context.quality = Defines.EQUIP_QUALITY.Rare

	var item = EquipmentGenerator.generate_item(context.quality, chosen_type)
	context.generated_item = item

	# 8. Roll perks
	# Execute BEFORE_PERK_ROLL hooks
	_execute_hook(Defines.ModifierHook.BEFORE_PERK_ROLL, context, modifiers)

	# Initialize perk weights from building specialization/type
	for p_idx in range(4): # Pwr, Spi, Wis, Agi
		context.perk_weights[p_idx] = 10.0

	# Tag pressures influence perk weights
	context.perk_weights[0] += smith * 1.5 + war * 1.0 + craft * 0.5
	context.perk_weights[1] += arc * 1.5 + charis * 1.0
	context.perk_weights[2] += arc * 0.5 + learn * 1.5 + steward * 1.0
	context.perk_weights[3] += war * 0.5 + steward * 1.0 + wild * 1.5

	var focus_idx = _roll_weighted(context.perk_weights)

	# Distribute rolled perks and attributes
	var total_perks = item.perk_points.reduce(func(accum, val): return accum + val, 0)
	var total_attrs = item.attributes.reduce(func(accum, val): return accum + val, 0)

	for i in range(item.perk_points.size()):
		item.perk_points[i] = 0
	item.perk_points[focus_idx] = total_perks

	for i in range(item.attributes.size()):
		item.attributes[i] = 0
	item.attributes[focus_idx] = total_attrs

	# 9. Execute perk hooks / AFTER_PERK_ROLL
	_execute_hook(Defines.ModifierHook.AFTER_PERK_ROLL, context, modifiers)

	# 10. Finalize item
	# Execute AFTER_ITEM_GENERATION hooks
	_execute_hook(Defines.ModifierHook.AFTER_ITEM_GENERATION, context, modifiers)

	# Default naming based on dominant tag and rolled stats
	var dominant_tag = -1
	var max_val = 0.0
	for tag in context.tags:
		if context.tags[tag] > max_val:
			max_val = context.tags[tag]
			dominant_tag = tag
	
	var tag_name = "Generic"
	if dominant_tag != -1:
		tag_name = Defines.PROG_TAG.keys()[dominant_tag]
	
	var type_name = Defines.EQUIP_TYPE.keys()[item.type]
	var quality_name = Defines.EQUIP_QUALITY.keys()[context.quality]
	item.display_name = "%s's %s %s" % [tag_name, quality_name, type_name]

	return item

func _execute_hook(hook: Defines.ModifierHook, context: GenerationContext, modifiers: Array[Modifier]) -> void:
	for modifier in modifiers:
		if not modifier: continue
		modifier.execute(hook, context)

func _roll_weighted(weights_dict: Dictionary) -> int:
	var total_weight := 0.0
	for key in weights_dict:
		total_weight += weights_dict[key]
	
	if total_weight <= 0.0:
		if not weights_dict.is_empty():
			return weights_dict.keys()[0]
		return 0

	var roll = 0.0
	if RunManager and RunManager.run_rng:
		roll = RunManager.run_rng.randf() * total_weight
	else:
		roll = randf() * total_weight

	var current_sum := 0.0
	for key in weights_dict:
		current_sum += weights_dict[key]
		if roll < current_sum:
			return key

	return weights_dict.keys()[0]

# Produce items from all buildings
func produce_items() -> Array[String]:
	# 1. Collect all global modifiers from all rooms and villagers across all buildings
	var global_mods: Array[Modifier] = []
	for building in buildings:
		if not building: continue
		for room in building.rooms:
			if not room: continue
			for mod in room.modifiers:
				if mod and mod.is_global:
					global_mods.append(mod)
			for villager in room.assigned_villagers:
				if not villager: continue
				for mod in villager.modifiers:
					if mod and mod.is_global:
						global_mods.append(mod)
				for v_trait in villager.traits:
					if v_trait and v_trait.is_global:
						global_mods.append(v_trait)

	# 2. Generate items for each building
	var results: Array[String] = []
	for building in buildings:
		if not building: continue
		var item = generate_item_via_pipeline(building, global_mods)
		var result = "%s produced: %s (Weight: %s, Perks: %s)" % [building.building_name, item.display_name, str(item.weight), str(item.perk_points)]
		results.append(result)
	
	if buildings.is_empty():
		results.append("No buildings to produce from!")
		
	return results

# Helper to find a room by name across all buildings
func find_room(room_name: String) -> Room:
	for building in buildings:
		for room in building.rooms:
			if room.room_name == room_name:
				return room
	return null

# Assign a villager to a room
func assign_villager_to_room(villager: Villager, room: Room) -> bool:
	if not villager: return false
	
	# Remove from previous room or reserve
	for b in buildings:
		for r in b.rooms:
			if r.assigned_villagers.has(villager):
				r.assigned_villagers.erase(villager)
	
	if reserve_villagers.has(villager):
		reserve_villagers.erase(villager)
	
	if room:
		room.assigned_villagers.append(villager)
	else:
		# If room is null, move to reserve
		reserve_villagers.append(villager)
		
	return true

# Helper to move villager to reserve
func move_to_reserve(villager: Villager) -> void:
	assign_villager_to_room(villager, null)

# Swap positions of two villagers
func swap_villagers(v1: Villager, v2: Villager) -> void:
	if v1 == v2: return
	
	# Find where v1 and v2 are currently
	var v1_room: Room = null
	var v2_room: Room = null
	
	for building in buildings:
		for room in building.rooms:
			if room.assigned_villagers.has(v1): v1_room = room
			if room.assigned_villagers.has(v2): v2_room = room
	
	# Swap them
	# If one is in reserve, assign_villager_to_room handles it correctly
	assign_villager_to_room(v1, v2_room)
	assign_villager_to_room(v2, v1_room)
