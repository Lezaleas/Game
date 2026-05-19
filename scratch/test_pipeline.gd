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

	# 2. Attach a Villager with Smithing/Crafting tags
	var smith = Villager.new()
	smith.name = "Test Smith"
	# Smithing (0) = 12, Crafting (4) = 5
	smith.tags = {
		Defines.PROG_TAG.Smithing: 12,
		Defines.PROG_TAG.Crafting: 5
	}
	
	# Attach villager to room
	room.assigned_villager = smith
	building.rooms.append(room)

	# 3. Create ProgressionManager manually
	var prog_manager = load("res://Systems/Progression/Logic/ProgressionManager.gd").new()
	prog_manager.buildings.append(building)

	# 4. Generate item via pipeline
	# Run pipeline manually first to inspect context
	var context = GenerationContext.new()
	context.building = building
	context.villagers = [smith] as Array[Villager]

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

	# Test full end-to-end generate function
	var generated_item = prog_manager.generate_item_via_pipeline(building)
	print("End-to-end generated item name: ", generated_item.display_name)
	print("End-to-end generated item skill: ", generated_item.skill.skill_name if generated_item.skill else "None")
	assert(generated_item.display_name.contains("Smithing"), "Item display name should be derived from dominant Smithing tag")

	# Create a high tag pressure building to ensure 100% chance of skill rolls for sample verification
	var hp_building = Building.new()
	hp_building.building_name = "High Pressure Forge"
	hp_building.specialization = Defines.EQUIP_TYPE.Sword
	hp_building.quality = 1.0 # Low quality means room_tags / quality is high!
	
	var hp_room = Room.new()
	hp_room.room_name = "HP Room"
	hp_room.element = Defines.PROG_ELEMENT.Fire
	
	var master_smith = Villager.new()
	master_smith.name = "Master Smith"
	master_smith.tags = {
		Defines.PROG_TAG.Smithing: 80.0,
		Defines.PROG_TAG.Crafting: 40.0
	}
	hp_room.assigned_villager = master_smith
	hp_building.rooms.append(hp_room)
	prog_manager.buildings.append(hp_building)

	print("--- Running 10 sample generations to check skill rolls ---")
	var skills_rolled = 0
	for i in range(10):
		var item = prog_manager.generate_item_via_pipeline(hp_building)
		if item.skill:
			skills_rolled += 1
			print("Sample %d: Rolled Skill '%s'" % [i + 1, item.skill.skill_name])
		else:
			print("Sample %d: No Skill" % [i + 1])
	print("Total skills rolled: ", skills_rolled, "/10")

	# Test TagSynergyModifier integration
	var synergy_context = GenerationContext.new()
	synergy_context.building = building
	synergy_context.villagers = [smith] as Array[Villager]
	synergy_context.tags = {
		Defines.PROG_TAG.Smithing: 20.0,
		Defines.PROG_TAG.Crafting: 10.0
	}
	
	var synergy_mod = TagSynergyModifier.new()
	synergy_mod.scaling_tag = Defines.PROG_TAG.Smithing
	synergy_mod.scaling_tag_2 = Defines.PROG_TAG.Crafting
	synergy_mod.chance = 5.0 # 20.0 * 5.0 = 100% chance
	synergy_mod.power = 0.5 # Increase by 20.0 * 0.5 = 10.0
	
	var test_mods: Array[Modifier] = [synergy_mod]
	
	print("Tags before TagSynergyModifier: Smithing: ", synergy_context.tags[Defines.PROG_TAG.Smithing], ", Crafting: ", synergy_context.tags[Defines.PROG_TAG.Crafting])
	prog_manager._execute_hook(Defines.ModifierHook.CALCULATE_TAG_PRESSURE, synergy_context, test_mods)
	print("Tags after TagSynergyModifier: Crafting: ", synergy_context.tags[Defines.PROG_TAG.Crafting])
	
	assert(synergy_context.tags[Defines.PROG_TAG.Crafting] == 20.0, "Crafting tag should be 10.0 (base) + 10.0 (synergy gain) = 20.0")

	# Verify produce_items output format
	var production_results = prog_manager.produce_items()
	print("Production Results: ", production_results)

	print("--- Tags, Traits, and Modifiers Item Pipeline Test Successful ---")
	get_tree().quit()
