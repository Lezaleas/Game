extends SceneTree

func _init() -> void:
	print("Starting generation...")
	var base_path = "res://Systems/Progression/Data/InitialState/"
	DirAccess.make_dir_recursive_absolute(base_path + "Buildings")
	DirAccess.make_dir_recursive_absolute(base_path + "Rooms")
	DirAccess.make_dir_recursive_absolute(base_path + "Villagers")
	
	# 1. Create Villagers
	var v_data = [
		{"name": "Blacksmith", "tag": Defines.PROG_TAG.Smithing},
		{"name": "Soldier", "tag": Defines.PROG_TAG.Warfare},
		{"name": "Mage", "tag": Defines.PROG_TAG.Arcane},
		{"name": "Scholar", "tag": Defines.PROG_TAG.Learning},
		{"name": "Artisan", "tag": Defines.PROG_TAG.Crafting},
		{"name": "Steward", "tag": Defines.PROG_TAG.Stewardry},
		{"name": "Innkeeper", "tag": Defines.PROG_TAG.Charisma},
		{"name": "Ranger", "tag": Defines.PROG_TAG.Wildcraft}
	]
	
	for v in v_data:
		var vil = Villager.new()
		vil.name = v["name"]
		vil.description = "A skilled " + v["name"]
		vil.tags[v["tag"]] = 5
		ResourceSaver.save(vil, base_path + "Villagers/" + v["name"] + ".tres")
		print("Saved Villager: " + v["name"])
	
	# 2. Create Rooms
	var r_data = [
		{"name": "Anvil Area", "element": Defines.PROG_ELEMENT.Fire},
		{"name": "Smelting Furnace", "element": Defines.PROG_ELEMENT.Fire},
		{"name": "Ritual Altar", "element": Defines.PROG_ELEMENT.Water},
		{"name": "Enchanting Circle", "element": Defines.PROG_ELEMENT.Water},
		{"name": "Assembly Bench", "element": Defines.PROG_ELEMENT.Earth},
		{"name": "Plating Station", "element": Defines.PROG_ELEMENT.Earth},
		{"name": "Leather Tannery", "element": Defines.PROG_ELEMENT.Wind},
		{"name": "Sewing Loom", "element": Defines.PROG_ELEMENT.Wind}
	]
	
	for r in r_data:
		var room = Room.new()
		room.room_name = r["name"]
		room.description = "A " + r["name"]
		room.element = r["element"]
		# Safe file name
		var fname = r["name"].replace(" ", "")
		ResourceSaver.save(room, base_path + "Rooms/" + fname + ".tres")
		print("Saved Room: " + r["name"])
		
	# 3. Create Buildings
	var b_data = [
		{"name": "Forge", "spec": Defines.EQUIP_TYPE.Sword},
		{"name": "Atelier", "spec": Defines.EQUIP_TYPE.Staff},
		{"name": "Armoury", "spec": Defines.EQUIP_TYPE.Armor},
		{"name": "Outfitter", "spec": Defines.EQUIP_TYPE.Boots}
	]
	
	for b in b_data:
		var bld = Building.new()
		bld.building_name = b["name"]
		bld.description = "A " + b["name"]
		bld.specialization = b["spec"]
		bld.quality = 10.0
		bld.produces = true
		# We DO NOT put rooms in the building resource array, as requested.
		ResourceSaver.save(bld, base_path + "Buildings/" + b["name"] + ".tres")
		print("Saved Building: " + b["name"])
	
	print("Generation Complete!")
	quit()
