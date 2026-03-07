extends Control

@onready var debug_label = $"DebugLabel"

func _ready():
	pass

## sets the debug label text
func set_debug_text(text: String):
	debug_label.text = text

func append_debug_text(text: String):
	debug_label.text += "\n" + text

func clear_debug_text():
	debug_label.text = ""
