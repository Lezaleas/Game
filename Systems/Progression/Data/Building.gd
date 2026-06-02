extends Resource
class_name Building

@export var building_name: String = ""
@export_multiline var description: String = ""
@export var rooms: Array[Room] = []
@export var specialization: Defines.EQUIP_TYPE = Defines.EQUIP_TYPE.Sword
@export var produces: = true
@export var quality := 10.0

# Helper to calculate total tag pressure for the building
func get_tag_pressure() -> Dictionary:
	var pressure = {}
	for tag in Defines.PROG_TAG.values():
		pressure[tag] = 0
	for room in rooms:
		if not room: continue
		var room_tags = room.get_total_tags()
		for tag in room_tags:
			pressure[tag] += room_tags[tag]/quality*100
	return pressure
