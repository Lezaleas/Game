extends PanelContainer

signal hovered(enemy_data: EnemyData)
signal slot_changed()

var enemy_data: EnemyData
var slot_index: int = 0

@onready var icon_rect: TextureRect = $VBoxContainer/Icon
@onready var info_label: RichTextLabel = $VBoxContainer/InfoLabel
@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var skills_label: RichTextLabel = $VBoxContainer/SkillsLabel

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)

func set_enemy(data: EnemyData) -> void:
	enemy_data = data
	if enemy_data:
		icon_rect.texture = enemy_data.icon
		info_label.text = get_info_text(enemy_data)
		name_label.text = enemy_data.id
		var skills_text = ""
		for skill in enemy_data.skills:
			if skill:
				skills_text += "[center]" + skill.skill_name + "[/center]\n"
		skills_label.text = skills_text.strip_edges()
	else:
		icon_rect.texture = null
		info_label.text = ""
		name_label.text = ""
		skills_label.text = ""

func get_info_text(data: EnemyData) -> String:
	if not data: return ""
	
	var role_str = Defines.ENEMY_ROLES.keys()[data.role]
	
	var path = data.resource_path
	var stage_idx = 0
	if path.find("Stage") != -1:
		var stage_str = path.get_base_dir().get_file().replace("Stage", "")
		if stage_str.is_valid_int():
			stage_idx = stage_str.to_int()
			
	var mult = pow(2.0, stage_idx)
	var profs = []
	for i in range(4):
		var base_val = data.attributes_base[i] / mult
		var rounded = round(base_val)
		if rounded <= 5: profs.append(1)
		elif rounded <= 7: profs.append(2)
		elif rounded <= 10: profs.append(3)
		elif rounded <= 14: profs.append(4)
		else: profs.append(5)
		
	var colors = ["red", "lightblue", "green", "yellow"]
	var stats_str = ""
	for i in range(4):
		stats_str += "[color=%s]%d[/color]" % [colors[i], profs[i]]
		
	return "[center]%s %s[/center]" % [role_str, stats_str]

func _on_mouse_entered() -> void:
	if enemy_data:
		hovered.emit(enemy_data)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("type") and data["type"] == "enemy_data"

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if typeof(data) == TYPE_DICTIONARY and data.has("data"):
		set_enemy(data["data"])
		slot_changed.emit()

func _get_drag_data(at_position: Vector2) -> Variant:
	if not enemy_data:
		return null
		
	var data = enemy_data
	
	var preview = TextureRect.new()
	preview.texture = enemy_data.icon
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = Vector2(64, 64)
	preview.modulate.a = 0.5
	set_drag_preview(preview)
	
	# Clear out the slot since we are dragging it away
	set_enemy(null)
	slot_changed.emit()
	
	return {"type": "enemy_data", "data": data}
