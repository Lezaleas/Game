class_name SkillSlot
extends Button

@onready var skill_icon: TextureRect = %SkillIcon
@onready var skill_name: Label = %SkillName
var skill: Skill
var index: int = -1
var source_array: Array[Skill]

func set_skill(skill_to_set: Skill) -> void:
	skill = skill_to_set
	if skill:
		skill_icon.texture = skill.icon
		skill_name.text = skill.skill_name
		skill_icon.show()
		skill_name.show()
	else:
		skill_icon.hide()
		skill_name.text = "---"
	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if skill:
			EventBus.emit("skill_hovered", skill)
		else:
			EventBus.emit("skill_hovered", null)

func _pressed() -> void:
	EventBus.emit("slot_clicked", self)
