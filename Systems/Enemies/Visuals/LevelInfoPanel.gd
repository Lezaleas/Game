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
	
	var enemies = [data.enemy0, data.enemy1, data.enemy2, data.enemy3]
	for enemy in enemies:
		if enemy:
			var lbl = Label.new()
			lbl.text = "- " + enemy.id
			enemies_list.add_child(lbl)
	
	reward_label.text = "Reward: " + (str(data.reward) if data.reward else "None")
	modifier_label.text = "Modifier: " + (str(data.modifier) if data.modifier else "None")
