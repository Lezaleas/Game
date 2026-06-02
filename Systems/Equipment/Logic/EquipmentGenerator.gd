class_name EquipmentGenerator
extends Node

## Generates a new EquipmentState procedurally based on quality and type
static func generate_item(quality_budget: float, type: Defines.EQUIP_TYPE, tags: Dictionary = {}) -> EquipmentState:
	var item = EquipmentState.new()
	item.type = type
	item.display_name = str(quality_budget) + " " + str(Defines.EQUIP_TYPE.keys()[type])
	# Assign default icon based on type
	match type:
		Defines.EQUIP_TYPE.Sword:
			item.icon = load("res://Assets/Sprites/Common/ElementalIcons/Red.tres")
		Defines.EQUIP_TYPE.Staff:
			item.icon = load("res://Assets/Sprites/Common/ElementalIcons/Blue.tres")
		Defines.EQUIP_TYPE.Armor:
			item.icon = load("res://Assets/Sprites/Common/ElementalIcons/Green.tres")
		Defines.EQUIP_TYPE.Boots:
			item.icon = load("res://Assets/Sprites/Common/ElementalIcons/Yellow.tres")
		_:
			item.icon = load("res://Assets/Sprites/Common/ElementalIcons/White.tres")
	
	# 1. Roll Weight (Weighted Bell Curve)
	item.weight = get_weighted_weight() / 10
	
	# 2. Calculate Perk Points (based on weight)
	var upgrade_points = (item.weight) / 10
	
	# 3. Roll for Attribute Focus
	#var attr_idx = RunManager.run_rng.randi() % 4
	var attr_idx := type # hardcoded stats size
	
	# 4. Adjudicate Perk Points to that order
	item.perk_points[attr_idx] = int(upgrade_points)
	
	# 5. Adjudicate Budget to that Attribute order
	item.attributes[attr_idx] = int(quality_budget)
	
	# 6. Roll for Skill
	if not tags.is_empty():
		var total_tag_pressure = 0.0
		for tag in tags:
			total_tag_pressure += tags[tag]
		
		var total_weight = max(100.0, total_tag_pressure)
		var roll = RunManager.run_rng.randf() * total_weight
		
		var current_sum = 0.0
		var selected_tag = -1
		for tag in tags:
			current_sum += tags[tag]
			if roll < current_sum:
				selected_tag = tag
				break
		
		if selected_tag != -1:
			var pool = RunManager.skill_pools.get(selected_tag, []) as Array[Skill]
			if pool and not pool.is_empty():
				var skill_idx = RunManager.run_rng.randi() % pool.size()
				item.skill = pool[skill_idx].duplicate()
			
	print("Generated Item: ", item.display_name, " Weight: ", item.weight, " Focus Index: ",
	attr_idx, " Attr Bonus: ", item.attributes[attr_idx], " Perks: ", item.perk_points[attr_idx],
	" Skill: ", item.skill.skill_name if item.skill else "None")
	return item

static func get_weighted_weight() -> int:
	var values = [10, 20, 30, 40]
	var chances = [25, 25, 25, 25]
	var total_chance = 0
	for c in chances: total_chance += c
	
	var roll = RunManager.run_rng.randi() % total_chance
	var current_sum = 0
	for i in range(values.size()):
		current_sum += chances[i]
		if roll < current_sum:
			return values[i]
			
	return 25 # Fallback
