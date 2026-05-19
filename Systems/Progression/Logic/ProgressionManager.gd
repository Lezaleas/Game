extends Node
# ProgressionManager
# Handles the logic for the Progression System (Buildings, Rooms, Villagers).

var buildings: Array[Building] = []
var villagers: Array[Villager] = []
var reserve_villagers: Array[Villager] = []
var last_calculated_tags: Dictionary = {}

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
	
	var synergy_mod = TagSynergyModifier.new()
	synergy_mod.scaling_tag = Defines.PROG_TAG.Smithing
	synergy_mod.scaling_tag_2 = Defines.PROG_TAG.Crafting
	synergy_mod.chance = 0.5 # 8 * 10 = 80% chance
	synergy_mod.power = 1
	v1.modifiers.append(synergy_mod)
	
	var v2 = Villager.new()
	v2.name = "Eir"
	v2.tags = {Defines.PROG_TAG.Arcane: 7, Defines.PROG_TAG.Learning: 5}
	
	var v3 = Villager.new()
	v3.name = "Gunnar"
	v3.tags = {Defines.PROG_TAG.Charisma: 6, Defines.PROG_TAG.Warfare: 3}
	
	reserve_villagers.append_array([v1, v2, v3])

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
		for r_mod in r.base_effects:
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
	var smith = context.tags.get(Defines.PROG_TAG.Smithing, 0.0)
	var war = context.tags.get(Defines.PROG_TAG.Warfare, 0.0)
	var arc = context.tags.get(Defines.PROG_TAG.Arcane, 0.0)
	var learn = context.tags.get(Defines.PROG_TAG.Learning, 0.0)
	var craft = context.tags.get(Defines.PROG_TAG.Crafting, 0.0)
	var steward = context.tags.get(Defines.PROG_TAG.Stewardry, 0.0)
	var charis = context.tags.get(Defines.PROG_TAG.Charisma, 0.0)
	var wild = context.tags.get(Defines.PROG_TAG.Wildcraft, 0.0)

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
	var quality_name = str(context.quality)
	item.display_name = "%s's %s %s" % [tag_name, quality_name, type_name]
	
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
	for building in buildings:
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
	for building in buildings:
		if not building: continue
		if not building.produces: continue
		var item = generate_item_via_pipeline(building, global_mods)
		var tags_str = ""
		for tag_id in range(8):
			tags_str += str(last_calculated_tags.get(tag_id, 0.0)) + ","
		var skill_name = item.skill.skill_name if item.skill else "None"
		var result = "%s produced: %s (Weight: %s, Perks: %s, Skill: %s) [%s]" % [building.building_name, item.display_name, str(item.weight), str(item.perk_points), skill_name, tags_str]
		results.append(result)
	
	if buildings.is_empty():
		results.append("No buildings to produce from!")
		
	return results

# Assign a villager to a room
func assign_villager_to_room(villager: Villager, room: Room) -> bool:
	if not villager: return false
	
	# Remove from previous room or reserve
	for b in buildings:
		for r in b.rooms:
			if r.assigned_villager == villager:
				r.assigned_villager = null
	
	if reserve_villagers.has(villager):
		reserve_villagers.erase(villager)
	
	if room:
		room.assigned_villager = villager
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
			if room.assigned_villager == v1: v1_room = room
			if room.assigned_villager == v2: v2_room = room
	
	# Swap them
	# If one is in reserve, assign_villager_to_room handles it correctly
	assign_villager_to_room(v1, v2_room)
	assign_villager_to_room(v2, v1_room)
