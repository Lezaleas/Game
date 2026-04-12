class_name EquipmentGenerator
extends Node

# Budget allocation per quality level
static var QUALITY_BUDGETS = {
	Defines.EQUIP_QUALITY.Common: 10,
	Defines.EQUIP_QUALITY.Rare: 25,
	Defines.EQUIP_QUALITY.Epic: 50,
	Defines.EQUIP_QUALITY.Legendary: 100
}

# Non-linear investment scaling for attributes
# Key: Investment Level Enum
# Value: Array of [Budget Cost, Attribute Bonus]
static var INVESTMENT_SCALING = {}

const PERK_POINT_COST = 4 # Cost per 1 perk point
const WEIGHT_RECO_COST = 2 # Cost per -2 weight reduction

## Generates a new EquipmentState procedurally based on quality and type
static func generate_item(quality: Defines.EQUIP_QUALITY, type: Defines.EQUIP_TYPE) -> EquipmentState:
	var item = EquipmentState.new()
	item.type = type
	item.display_name = str(Defines.EQUIP_QUALITY.keys()[quality]) + " " + str(Defines.EQUIP_TYPE.keys()[type])
	
	# 1. Roll Weight (Weighted Bell Curve)
	item.weight = get_weighted_weight()
	
	# 2. Calculate Perk Points (based on weight)
	var upgrade_points = (item.weight) / 10
	
	# 3. Roll for Attribute Focus
	#var attr_idx = RunManager.run_rng.randi() % 4
	var attr_idx: = type # hardcoded stats size
	
	# 4. Adjudicate Perk Points to that order
	item.perk_points[attr_idx] = int(upgrade_points + quality)
	
	# 5. Adjudicate Budget to that Attribute order
	item.attributes[attr_idx] = quality * upgrade_points * 5
			
	print("Generated Item: ", item.display_name, " Weight: ", item.weight, " Focus Index: ",
	attr_idx, " Attr Bonus: ", item.attributes[attr_idx], " Perks: ", item.perk_points[attr_idx])
	return item

static func get_weighted_weight() -> int:
	var values = [10,20,30,40]
	var chances = [25,25,25,25]
	var total_chance = 0
	for c in chances: total_chance += c
	
	var roll = RunManager.run_rng.randi() % total_chance
	var current_sum = 0
	for i in range(values.size()):
		current_sum += chances[i]
		if roll < current_sum:
			return values[i]
			
	return 25 # Fallback
