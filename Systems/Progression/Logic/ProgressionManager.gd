extends Node
# ProgressionManager
# Handles the logic for the Progression System (Buildings, Rooms, Villagers).

var last_calculated_tags: Dictionary = {}

func _ready() -> void:
	pass

	pass

# Runs the full 10-step item generation pipeline for a given building.
func generate_item_via_pipeline(building: Building, global_modifiers: Array[Modifier] = []) -> EquipmentState:
	# 1. Create GenerationContext
	var context = GenerationContext.new()
	context.building = building
	context.global_modifiers = global_modifiers
	context.quality = building.quality
	
	var all_villagers: Array[Villager] = []
	for r in building.rooms:
		if r:
			all_villagers.append(r.assigned_villager)
	context.villagers = all_villagers

	# 2. Calculate building tag pressure
	context.tags = building.get_tag_pressure().duplicate()

	# 3. Collect active modifiers and group them by hook type
	var modifiers_by_hook: Array[Array] = []
	modifiers_by_hook.resize(Defines.ModifierHook.keys().size())
	for i in range(modifiers_by_hook.size()):
		modifiers_by_hook[i] = [] as Array[Modifier]

	var register_modifier = func(mod: Modifier, r: Room, v: Villager):
		if not mod: return
		mod.room = r
		mod.villager = v
		for hook in mod.hook_type:
			modifiers_by_hook[hook].append(mod)

	for g_mod in global_modifiers:
		register_modifier.call(g_mod, null, null)

	for r in building.rooms:
		if not r: continue
		var v: Villager = r.assigned_villager
		for r_mod in r.modifiers:
			if r_mod and not r_mod.is_global:
				register_modifier.call(r_mod, r, v)
		if not v: continue
		for v_mod in v.modifiers:
			if v_mod and not v_mod.is_global:
				register_modifier.call(v_mod, r, v)
		for v_trait in v.traits:
			if v_trait and v_trait.is_global:
				register_modifier.call(v_trait, r, v)

	# Sort modifiers in each category by priority (highest priority first)
	for list in modifiers_by_hook:
		list.sort_custom(func(a, b): return a.priority > b.priority)

	# 4. Execute CALCULATE_TAG_PRESSURE hooks
	_execute_hook(Defines.ModifierHook.CALCULATE_TAG_PRESSURE, context, modifiers_by_hook[Defines.ModifierHook.CALCULATE_TAG_PRESSURE])

	# 5. Generate item category weights
	var chosen_type = building.specialization

	# Tag pressures influence base category weights
	@warning_ignore("unused_variable")
	var _smith = context.tags.get(Defines.PROG_TAG.Smithing, 0.0)
	@warning_ignore("unused_variable")
	var _war = context.tags.get(Defines.PROG_TAG.Warfare, 0.0)
	@warning_ignore("unused_variable")
	var _arc = context.tags.get(Defines.PROG_TAG.Arcane, 0.0)
	@warning_ignore("unused_variable")
	var _learn = context.tags.get(Defines.PROG_TAG.Learning, 0.0)
	@warning_ignore("unused_variable")
	var _craft = context.tags.get(Defines.PROG_TAG.Crafting, 0.0)
	@warning_ignore("unused_variable")
	var _steward = context.tags.get(Defines.PROG_TAG.Stewardry, 0.0)
	@warning_ignore("unused_variable")
	var _charis = context.tags.get(Defines.PROG_TAG.Charisma, 0.0)
	@warning_ignore("unused_variable")
	var _wild = context.tags.get(Defines.PROG_TAG.Wildcraft, 0.0)

	var item = EquipmentGenerator.generate_item(context.quality, chosen_type, context.tags)
	context.generated_item = item

	# 8. Roll perks
	# Execute BEFORE_PERK_ROLL hooks
	_execute_hook(Defines.ModifierHook.BEFORE_PERK_ROLL, context, modifiers_by_hook[Defines.ModifierHook.BEFORE_PERK_ROLL])

	# 9. Execute perk hooks / AFTER_PERK_ROLL
	_execute_hook(Defines.ModifierHook.AFTER_PERK_ROLL, context, modifiers_by_hook[Defines.ModifierHook.AFTER_PERK_ROLL])

	# 10. Finalize item
	# Execute AFTER_ITEM_GENERATION hooks
	_execute_hook(Defines.ModifierHook.AFTER_ITEM_GENERATION, context, modifiers_by_hook[Defines.ModifierHook.AFTER_ITEM_GENERATION])

	# Naming: "<stat value> <skill name>" or "<stat value> Generic"
	var skill_name = "Generic"
	if item.skill:
		skill_name = item.skill.skill_name
	var power_value = item.attributes[item.type]  # the attributed stat for this item type
	item.display_name = "%d %s" % [power_value, skill_name]

	
	last_calculated_tags = context.tags
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
	for building in RunManager.buildings:
		if not building: continue
		for room in building.rooms:
			if not room: continue
			for mod in room.modifiers:
				if mod and mod.is_global:
					mod.room = room
					mod.villager = room.assigned_villager
					global_mods.append(mod)
			var villager = room.assigned_villager
			if not villager: continue
			for mod in villager.modifiers:
				if mod and mod.is_global:
					mod.villager = villager
					mod.room = room
					global_mods.append(mod)
			for v_trait in villager.traits:
				if v_trait and v_trait.is_global:
					v_trait.villager = villager
					v_trait.room = room
					global_mods.append(v_trait)

	# 2. Generate items for each building
	var results: Array[String] = []
	for building in RunManager.buildings:
		if not building: continue
		if not building.produces: continue
		var item = generate_item_via_pipeline(building, global_mods)
		RunManager.equipment.append(item)
		var tags_str = ""
		for tag_id in range(8):
			tags_str += str(last_calculated_tags.get(tag_id, 0.0)) + ","
		var skill_name = item.skill.skill_name if item.skill else "None"
		var result = "%s produced: %s (Weight: %s, Perks: %s, Skill: %s) [%s]" % [building.building_name, item.display_name, str(item.weight), str(item.perk_points), skill_name, tags_str]
		results.append(result)
	
	if RunManager.buildings.is_empty():
		results.append("No buildings to produce from!")
		
	return results

# Assign a villager to a room
func assign_villager_to_room(villager: Villager, room: Room) -> bool:
	if not villager: return false
	
	# If the room already has an occupant, swap them instead
	if room and room.assigned_villager and room.assigned_villager != villager:
		swap_villagers(villager, room.assigned_villager)
		return true
	
	# Remove from previous room or reserve
	for b in RunManager.buildings:
		for r in b.rooms:
			if r.assigned_villager == villager:
				r.assigned_villager = null
	
	if RunManager.reserve_villagers.has(villager):
		RunManager.reserve_villagers.erase(villager)
	
	if room:
		room.assigned_villager = villager
	else:
		# If room is null, move to reserve
		RunManager.reserve_villagers.append(villager)
		
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
	var v1_in_reserve = RunManager.reserve_villagers.has(v1)
	var v2_in_reserve = RunManager.reserve_villagers.has(v2)
	
	for building in RunManager.buildings:
		for room in building.rooms:
			if room.assigned_villager == v1: v1_room = room
			if room.assigned_villager == v2: v2_room = room
	
	# Remove both from their spots
	if v1_room: v1_room.assigned_villager = null
	if v2_room: v2_room.assigned_villager = null
	if v1_in_reserve: RunManager.reserve_villagers.erase(v1)
	if v2_in_reserve: RunManager.reserve_villagers.erase(v2)
	
	# Assign v1 to v2's spot
	if v2_room: v2_room.assigned_villager = v1
	else: RunManager.reserve_villagers.append(v1)
	
	# Assign v2 to v1's spot
	if v1_room: v1_room.assigned_villager = v2
	else: RunManager.reserve_villagers.append(v2)
