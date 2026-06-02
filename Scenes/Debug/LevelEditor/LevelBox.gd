extends PanelContainer

signal enemy_hovered(enemy_data: EnemyData)

var level_data: LevelData

@onready var level_name_label: Label = $VBoxContainer/LevelName
@onready var slots = [
	$VBoxContainer/Slots/EnemySlot0,
	$VBoxContainer/Slots/EnemySlot1,
	$VBoxContainer/Slots/EnemySlot2,
	$VBoxContainer/Slots/EnemySlot3
]

@onready var sum_label: RichTextLabel = $VBoxContainer/Slots/SumPanel/Margin/VBox/SumLabel

func _ready() -> void:
	for i in range(slots.size()):
		var slot = slots[i]
		slot.slot_index = i
		slot.hovered.connect(_on_slot_hovered)
		if slot.has_signal("slot_changed"):
			slot.slot_changed.connect(_update_sums)

func setup(data: LevelData, path: String) -> void:
	level_data = data
	level_name_label.text = path.get_file().get_basename()
	
	if level_data:
		slots[0].set_enemy(level_data.enemy0)
		slots[1].set_enemy(level_data.enemy1)
		slots[2].set_enemy(level_data.enemy2)
		slots[3].set_enemy(level_data.enemy3)
	
	_update_sums()

func _update_sums() -> void:
	var sums = [0, 0, 0, 0]
	for slot in slots:
		var data = slot.enemy_data
		if data:
			var path = data.resource_path
			var stage_idx = 0
			if path.find("Stage") != -1:
				var stage_str = path.get_base_dir().get_file().replace("Stage", "")
				if stage_str.is_valid_int():
					stage_idx = stage_str.to_int()
					
			var mult = pow(2.0, stage_idx)
			for i in range(4):
				var base_val = data.attributes_base[i] / mult
				var rounded = round(base_val)
				if rounded <= 5: sums[i] += 1
				elif rounded <= 7: sums[i] += 2
				elif rounded <= 10: sums[i] += 3
				elif rounded <= 14: sums[i] += 4
				else: sums[i] += 5
				
	var colors = ["red", "lightblue", "green", "yellow"]
	var stats_str = ""
	for i in range(4):
		stats_str += "[color=%s]%d[/color] " % [colors[i], sums[i]]
		
	sum_label.text = "[center]%s[/center]" % stats_str.strip_edges()

func _on_slot_hovered(data: EnemyData) -> void:
	enemy_hovered.emit(data)

func save_to_data() -> void:
	if level_data:
		level_data.enemy0 = slots[0].enemy_data
		level_data.enemy1 = slots[1].enemy_data
		level_data.enemy2 = slots[2].enemy_data
		level_data.enemy3 = slots[3].enemy_data
