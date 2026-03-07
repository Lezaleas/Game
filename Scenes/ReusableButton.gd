extends Button
class_name ReusableButton

@export var item_id: ButtonHandler.ITEM_IDS
@export var tooltip_data: Dictionary
@onready var highlight: ColorRect = $Highlight

func _ready():
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	pressed.connect(_on_pressed)
	mouse_entered.connect(func(): grab_focus())

func _on_focus_entered():
	highlight.visible = true
	EventBus.emit("item_focused", item_id)
	EventBus.emit("tooltip_requested", tooltip_data)

func _on_focus_exited():
	highlight.visible = false
	
func _on_pressed():
	EventBus.emit("item_activated", item_id)
