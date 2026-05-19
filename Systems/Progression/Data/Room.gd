extends Resource
class_name Room

@export var room_name: String = "New Room"
@export_multiline var description: String = ""
@export var element: Defines.PROG_ELEMENT = Defines.PROG_ELEMENT.Fire
@export var scaling_rules: Dictionary = {} # PROG_TAG -> Effect string or multiplier
@export var base_effects: Array[Modifier] = []
@export var assigned_villager: Villager
@export var modifiers: Array[Modifier] = []

# Helper to calculate total tags in this room
func get_total_tags() -> Dictionary:
	var total = {}
	if not assigned_villager: return total
	for tag in assigned_villager.tags:
		if not total.has(tag):
			total[tag] = 0
		total[tag] += assigned_villager.tags[tag]
	return total
