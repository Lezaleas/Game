extends Resource
class_name Building

@export var building_name: String = ""
@export_multiline var description: String = ""

@export var rooms: Array[Room] = []

# Specialization bias for item generation
@export var specialization: String = ""

# Helper to calculate total tag pressure for the building
func get_tag_pressure() -> Dictionary:
	var pressure = {}
	for room in rooms:
		if not room: continue
		var room_tags = room.get_total_tags()
		for tag in room_tags:
			if not pressure.has(tag):
				pressure[tag] = 0
			pressure[tag] += room_tags[tag]
	return pressure
