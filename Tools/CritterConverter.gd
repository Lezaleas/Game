@tool
extends EditorScript

func _run() -> void:
	var base_path = "res://Systems/Enemies/EnemyData/"
	var out_path = "res://Systems/Run/Data/Critters/"
	
	# ensure output directory exists
	var dir = DirAccess.open("res://")
	if not dir.dir_exists("Systems/Run/Data/Critters"):
		dir.make_dir_recursive("Systems/Run/Data/Critters")

	var stages = ["Stage0", "Stage1", "Stage2", "Stage3"]
	var count = 0
	
	for stage in stages:
		var stage_path = base_path + stage
		var stage_dir = DirAccess.open(stage_path)
		if stage_dir:
			stage_dir.list_dir_begin()
			var file_name = stage_dir.get_next()
			while file_name != "":
				if file_name.ends_with(".tres") and not file_name.begins_with("."):
					var enemy = ResourceLoader.load(stage_path + "/" + file_name) as EnemyData
					if enemy:
						var critter = Critter.new()
						critter.ConvertFromEnemy(enemy)
						
						var save_path = out_path + file_name.replace(".tres", "_" + stage + ".tres")
						var err = ResourceSaver.save(critter, save_path)
						if err == OK:
							count += 1
							print("Converted: ", enemy.id, " -> ", save_path)
						else:
							push_warning("Failed to save critter: " + save_path)
				file_name = stage_dir.get_next()
	print("Done! Converted ", count, " enemies to critters.")
