extends Node2D

func _ready() -> void:
	print("--- Testing Progression System Foundation ---")
	
	# 1. Create a Villager
	var blacksmith = Villager.new()
	blacksmith.name = "John the Smith"
	# Using literal values to avoid Defines Autoload issues if any
	# Metal = 0, Martial = 1
	blacksmith.tags = {
		0: 5,
		1: 3
	}
	print("Created Villager: ", blacksmith.name, " with tags ", blacksmith.tags)
	
	# 2. Create a Room
	var forge_room = Room.new()
	forge_room.room_name = "Main Forge"
	
	forge_room.assigned_villager = blacksmith
	
	var room_tags = forge_room.get_total_tags()
	print("Room '", forge_room.room_name, "' total tags: ", room_tags)
	assert(room_tags[0] == 5)
	
	# 3. Create a Building
	var forge_building = Building.new()
	forge_building.building_name = "The Grand Forge"
	
	var r_array: Array[Room] = []
	r_array.append(forge_room)
	forge_building.rooms = r_array
	
	var building_pressure = forge_building.get_tag_pressure()
	print("Building '", forge_building.building_name, "' pressure: ", building_pressure)
	
	# 4. Test RunManager integration
	RunManager.buildings.clear()
	RunManager.buildings.append(forge_building)
	print("RunManager buildings array successfully loaded.")
	
	print("--- Foundation Test Successful ---")
	get_tree().quit()
