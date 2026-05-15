extends Node
# ProgressionManager
# Handles the logic for the Progression System (Buildings, Rooms, Villagers).

var buildings: Array[Building] = []
var villagers: Array[Villager] = []
var reserve_villagers: Array[Villager] = []

func _ready() -> void:
	# Initial setup (this might be handled by RunManager in the future)
	if buildings.is_empty():
		_setup_debug_data()

func _setup_debug_data() -> void:
	# Create Forge
	var forge = Building.new()
	forge.building_name = "Iron Forge"
	forge.specialization = "Blade"
	
	var anvil_room = Room.new()
	anvil_room.room_name = "Anvil Area"
	anvil_room.element = Defines.PROG_ELEMENT.Fire
	
	forge.rooms.append(anvil_room)
	buildings.append(forge)
	
	# Create Atelier
	var atelier = Building.new()
	atelier.building_name = "Mystic Atelier"
	atelier.specialization = "Relic"
	
	var altar_room = Room.new()
	altar_room.room_name = "Ritual Altar"
	altar_room.element = Defines.PROG_ELEMENT.Arcane
	
	atelier.rooms.append(altar_room)
	buildings.append(atelier)
	
	# Create some villagers in reserve
	var v1 = Villager.new()
	v1.name = "Buliwyf"
	v1.tags = {Defines.PROG_TAG.Metal: 8, Defines.PROG_TAG.Martial: 4}
	
	var v2 = Villager.new()
	v2.name = "Eir"
	v2.tags = {Defines.PROG_TAG.Arcane: 7, Defines.PROG_TAG.Spirit: 5}
	
	var v3 = Villager.new()
	v3.name = "Gunnar"
	v3.tags = {Defines.PROG_TAG.Precision: 6, Defines.PROG_TAG.Metal: 3}
	
	reserve_villagers.append_array([v1, v2, v3])

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
	var pressure = get_global_tag_pressure()
	# ... implementation of week advancement ...
	print("Tag pressure at end of week: ", pressure)

# Produce items from all buildings
func produce_items() -> Array[String]:
	var results: Array[String] = []
	for building in buildings:
		var pressure = building.get_tag_pressure()
		var item_name = "Generic Item"
		
		# Very simple logic for testing: find dominant tag
		var dominant_tag = -1
		var max_val = 0
		for tag in pressure:
			if pressure[tag] > max_val:
				max_val = pressure[tag]
				dominant_tag = tag
		
		if dominant_tag != -1:
			var tag_name = Defines.PROG_TAG.keys()[dominant_tag]
			item_name = "%s's %s" % [tag_name, building.specialization if building.specialization else "Product"]
		
		var result = "%s produced: %s (Pressure: %s)" % [building.building_name, item_name, str(pressure)]
		results.append(result)
	
	if buildings.is_empty():
		results.append("No buildings to produce from!")
		
	return results

# Helper to find a room by name across all buildings
func find_room(room_name: String) -> Room:
	for building in buildings:
		for room in building.rooms:
			if room.room_name == room_name:
				return room
	return null

# Assign a villager to a room
func assign_villager_to_room(villager: Villager, room: Room) -> bool:
	if not villager: return false
	
	# Remove from previous room or reserve
	for b in buildings:
		for r in b.rooms:
			if r.assigned_villagers.has(villager):
				r.assigned_villagers.erase(villager)
	
	if reserve_villagers.has(villager):
		reserve_villagers.erase(villager)
	
	if room:
		room.assigned_villagers.append(villager)
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
			if room.assigned_villagers.has(v1): v1_room = room
			if room.assigned_villagers.has(v2): v2_room = room
	
	# Swap them
	# If one is in reserve, assign_villager_to_room handles it correctly
	assign_villager_to_room(v1, v2_room)
	assign_villager_to_room(v2, v1_room)
