extends Control
class_name AbilityInfoPanel

#@onready var icon: TextureRect = %Icon
@onready var name_label: Label = %NameLabel
@onready var description: RichTextLabel = %DescriptionLabel

func _ready() -> void:
	EventBus.subscribe("skill_hovered", self, "show_skill")

func show_skill(skill: Skill = null) -> void:
	if skill == null:
		return
	name_label.text = skill.skill_name
	_update_description(skill)

func clear() -> void:
	name_label.text = ""
	description.clear()

func _update_description(skill: Skill) -> void:
	description.clear()
	description.append_text(skill.description)
