extends Resource
class_name Room

@export var room_name: String = "New Room"
@export_multiline var description: String = ""
@export var element: Defines.PROG_ELEMENT = Defines.PROG_ELEMENT.Fire
@export var base_effect: String = ""
@export var scaling_rules: Dictionary = {} # PROG_TAG -> Effect string or multiplier
@export var tradeoffs: Array[String] = []
# Thresholds: PROG_TAG (int) -> Value (int) -> Effect (String/Resource)
@export var thresholds: Dictionary = {}
@export var assigned_villagers: Array[Villager] = []
@export var modifiers: Array[Modifier] = []

# Helper to calculate total tags in this room
func get_total_tags() -> Dictionary:
	var total = {}
	for villager in assigned_villagers:
		if not villager: continue
		for tag in villager.tags:
			if not total.has(tag):
				total[tag] = 0
			print(total)
			total[tag] += villager.tags[tag]
	return total
