extends Control
class_name AbilityInfoPanel

#@onready var icon: TextureRect = %Icon
@onready var name_label: Label = %NameLabel
@onready var description: RichTextLabel = %DescriptionLabel

func _ready() -> void:
	EventBus.subscribe("skill_hovered", self, "show_skill")

func show_skill(data) -> void:
	if data is Perk:
		name_label.text = data.display_name
		description.text = data.description
	if data is Skill:
		name_label.text = data.skill_name
		description.text = data.description

func clear() -> void:
	name_label.text = ""
	description.clear()
