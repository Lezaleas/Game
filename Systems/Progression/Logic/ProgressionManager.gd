extends Node
# ProgressionManager
# Handles the logic for the Progression System (Buildings, Rooms, Villagers).

var buildings: Array[Building] = []
var villagers: Array[Villager] = []

func _ready() -> void:
	# Initial setup (this might be handled by RunManager in the future)
	pass

# Calculate total tag pressure for all buildings
func get_global_tag_pressure() -> Dictionary:
	var global_pressure = {}
	for building in buildings:
		var building_pressure = building.get_tag_pressure()
		for tag in building_pressure:
			if not global_pressure.has(tag):
				global_pressure[tag] = 0
			global_pressure[tag] += building_pressure[tag]
	return global_pressure

# Get pressure for a specific building
func get_building_pressure(building_name: String) -> Dictionary:
	for building in buildings:
		if building.building_name == building_name:
			return building.get_tag_pressure()
	return {}

# Advance the week (Weekly Loop logic)
func advance_week() -> void:
	print("Advancing progression week...")
	# 1. Calculate tag pressures (this happens on-demand usually, but we can cache it)
	var pressure = get_global_tag_pressure()
	
	# 2. Trigger room effects/scaling (to be implemented)
	
	# 3. Handle item generation opportunities (to be implemented)
	
	print("Tag pressure at end of week: ", pressure)

# Helper to find a room by name across all buildings
func find_room(room_name: String) -> Room:
	for building in buildings:
		for room in building.rooms:
			if room.room_name == room_name:
				return room
	return null

# Assign a villager to a room
func assign_villager_to_room(villager: Villager, room: Room) -> bool:
	if not room or not villager: return false
	
	# Remove from previous room if any
	for b in buildings:
		for r in b.rooms:
			if r.assigned_villagers.has(villager):
				r.assigned_villagers.erase(villager)
	
	room.assigned_villagers.append(villager)
	return true
