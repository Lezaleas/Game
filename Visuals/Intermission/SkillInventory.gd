extends Control
class_name SkillGrid

@export var columns: int = 5
@onready var grid: GridContainer = %GridContainer
@onready var slot_scene := preload("res://Visuals/Intermission/SkillSlot.tscn") as PackedScene
var slots: Array[SkillSlot] = []

func _ready() -> void:
	grid.columns = columns

func populate(skills: Array[Skill], fixed_size: int = -1) -> void:
	_clear()
	var count = skills.size()
	if fixed_size > 0:
		count = fixed_size
	
	for i in range(count):
		var slot: SkillSlot = slot_scene.instantiate()
		grid.add_child(slot)
		slots.append(slot)
		
		slot.index = i
		slot.source_array = skills
		
		var skill: Skill = null
		if i < skills.size():
			skill = skills[i]
		
		slot.set_skill(skill)

func _clear() -> void:
	for slot in slots:
		if is_instance_valid(slot):
			slot.queue_free()
	slots.clear()

func _on_slot_focused(skill: Skill) -> void:
	EventBus.emit("skill_hovered", skill)

func _on_slot_pressed(slot: SkillSlot) -> void:
	EventBus.emit("skill_clicked", slot)
