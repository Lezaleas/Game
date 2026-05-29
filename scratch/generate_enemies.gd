extends SceneTree

func _init() -> void:
	print("Generating enemy data...")
	
	var in_base = "res://Assets/Sprite_frames/"
	var out_base = "res://Systems/Enemies/EnemyData/"
	
	var stages = ["Stage0", "Stage1", "Stage2", "Stage3"]
	var stat_map = {"Stage0": 10, "Stage1": 20, "Stage2": 40, "Stage3": 80}
	
	for stage in stages:
		DirAccess.make_dir_recursive_absolute(out_base + stage)
		var in_dir = DirAccess.open(in_base + stage)
		if not in_dir: continue
		
		var stat = stat_map[stage]
		
		in_dir.list_dir_begin()
		var file_name = in_dir.get_next()
		while file_name != "":
			if not in_dir.current_is_dir() and file_name.ends_with(".tres"):
				var enemy = EnemyData.new()
				var id_name = file_name.replace(".tres", "")
				enemy.id = id_name
				enemy.sprite = load(in_base + stage + "/" + file_name) as SpriteFrames
				enemy.attributes_base = [stat, stat, stat, stat, 0, 0, 0, 0, 0, 0, 0]
				ResourceSaver.save(enemy, out_base + stage + "/" + file_name)
				print("Saved " + id_name + " in " + stage)
			file_name = in_dir.get_next()
			
	print("Done generating enemy data!")
	quit()
