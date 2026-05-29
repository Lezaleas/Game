extends SceneTree

func _init() -> void:
	print("Starting sprite frame fix...")
	var base_dir = "res://Assets/Sprite_frames/"
	var stages = ["Stage0", "Stage1", "Stage2", "Stage3"]
	
	for stage in stages:
		var dir_path = base_dir + stage
		var dir = DirAccess.open(dir_path)
		if not dir:
			continue
			
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				_fix_sprite_frame(dir_path + "/" + file_name, stage, file_name)
			file_name = dir.get_next()
	
	print("Fix complete!")
	quit()

func _fix_sprite_frame(path: String, stage: String, file_name: String) -> void:
	var frames = load(path) as SpriteFrames
	if not frames:
		print("Failed to load: " + path)
		return
		
	# Try to find the base texture
	var base_texture: Texture2D = null
	for anim in frames.get_animation_names():
		if frames.get_frame_count(anim) > 0:
			var tex = frames.get_frame_texture(anim, 0)
			if tex is AtlasTexture:
				base_texture = tex.atlas
				break
	
	# Fallback if no atlas texture found
	if not base_texture:
		var tex_name = file_name.replace(".tres", "")
		var tex_stage = stage.replace("Stage", "Stage ")
		var tex_path = "res://Assets/Sprites/Fighters/" + tex_stage + "/" + tex_name + ".png"
		base_texture = load(tex_path) as Texture2D
		if not base_texture:
			print("Could not find texture for: " + path)
			return

	var rects = {
		"clashing": [Rect2(32, 32, 16, 16)],
		"damaged": [Rect2(16, 48, 16, 16), Rect2(0, 48, 16, 16)],
		"default": [Rect2(0, 0, 16, 16), Rect2(16, 0, 16, 16)],
		"magic": [Rect2(0, 16, 16, 16)]
	}

	frames.clear_all()
	for anim in ["clashing", "damaged", "default", "magic"]:
		frames.add_animation(anim)
		frames.set_animation_loop(anim, anim == "default")
		frames.set_animation_speed(anim, 5.0)
		for rect in rects[anim]:
			var atlas_tex = AtlasTexture.new()
			atlas_tex.atlas = base_texture
			atlas_tex.region = rect
			frames.add_frame(anim, atlas_tex)
			
	ResourceSaver.save(frames, path)
	print("Updated: " + file_name)
