extends Node2D

func _ready() -> void:
	print("--- Testing Tags, Traits, and Modifiers Item Pipeline ---")

	# 1. Create a mock Building, Room, and Villager
	var building = Building.new()
	building.building_name = "Test Forge"
	building.specialization = Defines.EQUIP_TYPE.Sword
	building.quality = 20.0 # Base quality

	var room = Room.new()
	room.room_name = "Testing Fire Room"
	room.element = Defines.PROG_ELEMENT.Fire

	# 2. Attach a Villager with Smithing/Crafting tags and HeavyArmorModifier
	var smith = Villager.new()
	smith.name = "Test Smith"
	# Smithing (0) = 12, Crafting (4) = 5
	smith.tags = {
		Defines.PROG_TAG.Smithing: 12,
		Defines.PROG_TAG.Crafting: 5
	}
	
	# Add modifier to the villager
	var heavy_armor_mod = HeavyArmorModifier.new()
	smith.modifiers.append(heavy_armor_mod)
	print("Created Villager: ", smith.name, " with HeavyArmorModifier.")

	# Attach villager to room
	var villagers: Array[Villager] = [smith]
	room.assigned_villagers = villagers
	building.rooms.append(room)

	# 3. Create ProgressionManager manually (or use autoload, but manually is safer for test scenes)
	var prog_manager = load("res://Systems/Progression/Logic/ProgressionManager.gd").new()
	prog_manager.buildings.append(building)

	# 4. Generate item via pipeline
	# Run pipeline manually first to inspect context
	var context = GenerationContext.new()
	context.building = building
	context.villagers = room.assigned_villagers

	# Simulate Pipeline step-by-step to assert state mutations:
	# Calculate base tags pressure: quality (20) + villager tags
	var tags_pressure = {}
	for tag in Defines.PROG_TAG.values():
		tags_pressure[tag] = building.quality
	
	var room_tags = room.get_total_tags()
	for tag in room_tags:
		tags_pressure[tag] = tags_pressure.get(tag, 0.0) + room_tags[tag]
	
	context.tags = tags_pressure
	print("Initial Tags Pressure: ", context.tags)
	assert(context.tags[Defines.PROG_TAG.Smithing] == 32.0, "Smithing pressure should be quality (20) + villager (12) = 32")

	# Collect and sort modifiers
	var modifiers: Array[Modifier] = []
	for r in building.rooms:
		if not r: continue
		modifiers.append_array(r.modifiers)
		for v in r.assigned_villagers:
			if not v: continue
			modifiers.append_array(v.modifiers)
			modifiers.append_array(v.traits)
	
	assert(modifiers.size() == 1, "Should have collected exactly 1 modifier")
	assert(modifiers[0] is HeavyArmorModifier, "Collected modifier should be HeavyArmorModifier")

	# Calculate base weights
	for type in Defines.EQUIP_TYPE.values():
		if type == building.specialization:
			context.item_weights[type] = 50.0
		else:
			context.item_weights[type] = 10.0

	# Tag pressures influence base category weights
	var smith_pressure = context.tags.get(Defines.PROG_TAG.Smithing, 0.0)
	var craft_pressure = context.tags.get(Defines.PROG_TAG.Crafting, 0.0)
	context.item_weights[Defines.EQUIP_TYPE.Sword] += smith_pressure * 1.5
	context.item_weights[Defines.EQUIP_TYPE.Armor] += craft_pressure * 1.5 + smith_pressure * 1.0

	var sword_weight_before = context.item_weights[Defines.EQUIP_TYPE.Sword]
	var armor_weight_before = context.item_weights[Defines.EQUIP_TYPE.Armor]
	print("Category Weights before Modifier: Sword: ", sword_weight_before, ", Armor: ", armor_weight_before)

	# Execute CALCULATE_ITEM_WEIGHTS hook
	prog_manager._execute_hook(Defines.ModifierHook.CALCULATE_ITEM_WEIGHTS, context, modifiers)
	
	var armor_weight_after = context.item_weights[Defines.EQUIP_TYPE.Armor]
	print("Category Weights after HeavyArmorModifier: Armor: ", armor_weight_after)
	assert(armor_weight_after == armor_weight_before + 25.0, "Armor weight should be increased by 25 due to Fire room HeavyArmorModifier")

	# Test perk weight modifier (PreciseSmithingModifier)
	# Set up another villager with PreciseSmithingModifier in traits
	var scholar = Villager.new()
	scholar.name = "Test Scholar"
	var precise_mod = PreciseSmithingModifier.new()
	scholar.traits.append(precise_mod)
	room.assigned_villagers.append(scholar)

	# Re-collect modifiers
	modifiers.clear()
	for r in building.rooms:
		if not r: continue
		modifiers.append_array(r.modifiers)
		for v in r.assigned_villagers:
			if not v: continue
			modifiers.append_array(v.modifiers)
			modifiers.append_array(v.traits)
	
	modifiers.sort_custom(func(a, b): return a.priority > b.priority)
	assert(modifiers.size() == 2, "Should have collected 2 modifiers")
	assert(modifiers[0] is PreciseSmithingModifier, "PreciseSmithingModifier has priority 10 so it must be first in sorted order")

	# Initialize perk weights
	for p_idx in range(4):
		context.perk_weights[p_idx] = 10.0
	
	# Smithing (32) >= 10, so PreciseSmithingModifier will trigger on BEFORE_PERK_ROLL
	var pwr_weight_before = context.perk_weights[0]
	prog_manager._execute_hook(Defines.ModifierHook.BEFORE_PERK_ROLL, context, modifiers)
	var pwr_weight_after = context.perk_weights[0]
	print("Perk Power Weights before hook: ", pwr_weight_before, ", after: ", pwr_weight_after)
	assert(pwr_weight_after == pwr_weight_before + 15.0, "Power perk weight should be increased by 15 by PreciseSmithingModifier")

	# Test full end-to-end generate function
	var generated_item = prog_manager.generate_item_via_pipeline(building)
	print("End-to-end generated item name: ", generated_item.display_name)
	assert(generated_item.display_name.contains("Smithing"), "Item display name should be derived from dominant Smithing tag")

	# Test global modifiers integration
	var global_mod = HeavyArmorModifier.new()
	var global_mods: Array[Modifier] = [global_mod]
	var item_with_global = prog_manager.generate_item_via_pipeline(building, global_mods)
	print("Generated item with global modifiers: ", item_with_global.display_name)
	assert(item_with_global != null, "Should successfully generate item with global modifiers")

	# Test WeightTransformationModifier integration
	var gunnar = Villager.new()
	gunnar.name = "Gunnar"
	var weight_mod = WeightTransformationModifier.new()
	gunnar.modifiers.append(weight_mod)
	room.assigned_villagers.append(gunnar)
	
	var item_with_weight = prog_manager.generate_item_via_pipeline(building)
	print("Item weight before modification: default base, after Heavyweight Infusion: ", item_with_weight.weight)
	assert(item_with_weight.weight > 100, "Item weight should be increased by 100 due to WeightTransformationModifier on Fire room")

	print("--- Tags, Traits, and Modifiers Item Pipeline Test Successful ---")
	get_tree().quit()
