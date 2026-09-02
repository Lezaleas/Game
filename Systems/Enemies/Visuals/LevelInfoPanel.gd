extends PanelContainer
class_name LevelInfoPanel

@onready var name_label: Label = %LevelName
@onready var enemies_list: VBoxContainer = %EnemiesList
@onready var reward_label: Label = %RewardLabel
@onready var modifier_label: Label = %ModifierLabel

func display(data: LevelData) -> void:
	show()
	name_label.text = data.id
	
	# Clear previous enemies
	for child in enemies_list.get_children():
		child.queue_free()
	
	var enemies := [data.enemy0, data.enemy1, data.enemy2, data.enemy3]
	for enemy in enemies:
		if enemy == null: continue
		_add_label("- %s" % enemy.id)

		for skill in enemy.skills:
			if skill == null:continue
			_add_label(skill.skill_name, skill.description)
	
	if data.rewards.is_empty():
		reward_label.text = "Reward: None"
	else:
		var reward_strings := []
		for reward in data.rewards:
			if reward:
				reward_strings.append(reward.get_description())
		reward_label.text = "Rewards: " + ", ".join(reward_strings)


func _add_label(text: String, tooltip: String = "") -> void:
	var lbl := Label.new()
	lbl.text = text
	if not tooltip.is_empty():
		lbl.tooltip_text = tooltip
		lbl.mouse_filter = Control.MOUSE_FILTER_PASS
	enemies_list.add_child(lbl)
