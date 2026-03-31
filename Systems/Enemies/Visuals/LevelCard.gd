extends MarginContainer
class_name LevelCard

@onready var label: Label = %Label
@onready var button: Button = %Button

var level_data: LevelData

signal selected(data: LevelData)
signal hovered(data: LevelData)

func setup(data: LevelData) -> void:
	level_data = data
	label.text = data.id
	button.pressed.connect(_on_pressed)
	button.mouse_entered.connect(_on_mouse_entered)

func _on_pressed() -> void:
	selected.emit(level_data)

func _on_mouse_entered() -> void:
	hovered.emit(level_data)
