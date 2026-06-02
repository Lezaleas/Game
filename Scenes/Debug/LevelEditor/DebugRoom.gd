extends MarginContainer

var enemy_card_scene = preload("res://Scenes/Debug/LevelEditor/EnemyCard.tscn")
var level_box_scene = preload("res://Scenes/Debug/LevelEditor/LevelBox.tscn")

@onready var stage_tabs: TabContainer = $HBoxContainer/LeftPanel/StageTabs
@onready var level_tabs: TabContainer = $HBoxContainer/CenterPanel/LevelTabs
@onready var inspector: PanelContainer = $HBoxContainer/RightPanel/InspectorPanel
@onready var save_button: Button = $HBoxContainer/RightPanel/SaveButton

func _ready() -> void:
	save_button.pressed.connect(_on_save_pressed)
	_load_enemies()
	_load_levels()

func _load_enemies() -> void:
	var enemy_data_dir = "res://Systems/Enemies/EnemyData/"
	var dir = DirAccess.open(enemy_data_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name.begins_with("Stage"):
				_create_stage_tab(enemy_data_dir + file_name + "/", file_name)
			file_name = dir.get_next()
	else:
		print("Failed to open EnemyData directory")

func _create_stage_tab(stage_path: String, stage_name: String) -> void:
	var scroll = ScrollContainer.new()
	scroll.name = stage_name
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 5)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 5)
	margin.add_theme_constant_override("margin_bottom", 5)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)
	
	var flow = HFlowContainer.new()
	flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	flow.size_flags_vertical = Control.SIZE_EXPAND_FILL
	flow.add_theme_constant_override("h_separation", 25)
	flow.add_theme_constant_override("v_separation", 15)
	margin.add_child(flow)
	
	stage_tabs.add_child(scroll)
	
	var dir = DirAccess.open(stage_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var res_path = stage_path + file_name
				var enemy_data = load(res_path) as EnemyData
				if enemy_data:
					var card = enemy_card_scene.instantiate()
					flow.add_child(card)
					card.setup(enemy_data)
					card.hovered.connect(_on_enemy_hovered)
			file_name = dir.get_next()

func _load_levels() -> void:
	var level_data_dir = "res://Systems/Enemies/LevelData/"
	var dir = DirAccess.open(level_data_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name.begins_with("Stage"):
				_create_level_tab(level_data_dir + file_name + "/", file_name)
			file_name = dir.get_next()

func _create_level_tab(stage_path: String, stage_name: String) -> void:
	var scroll = ScrollContainer.new()
	scroll.name = stage_name
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 5)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 5)
	margin.add_theme_constant_override("margin_bottom", 5)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)
	
	level_tabs.add_child(scroll)
	
	var dir = DirAccess.open(stage_path)
	if dir:
		var level_files = []
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				level_files.append(file_name)
			file_name = dir.get_next()
			
		level_files.sort()
		
		for lf in level_files:
			var res_path = stage_path + lf
			var level_data = load(res_path) as LevelData
			if level_data:
				var box = level_box_scene.instantiate()
				vbox.add_child(box)
				box.setup(level_data, lf)
				box.enemy_hovered.connect(_on_enemy_hovered)

func _on_enemy_hovered(enemy_data: EnemyData) -> void:
	inspector.display(enemy_data)

func _on_save_pressed() -> void:
	print("Saving LevelData...")
	for tab in level_tabs.get_children():
		var margin = tab.get_child(0)
		var vbox = margin.get_child(0)
		for box in vbox.get_children():
			if box.has_method("save_to_data"):
				box.save_to_data()
				var err = ResourceSaver.save(box.level_data, box.level_data.resource_path)
				if err != OK:
					print("Error saving: ", box.level_data.resource_path)
				else:
					print("Saved: ", box.level_data.resource_path)
	print("Save Complete!")
