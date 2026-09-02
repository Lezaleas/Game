class_name ChoiceNodeButton
extends Button

signal clicked(node)
@onready var texture: TextureRect = %Icon
@onready var label: Label = %Label
var node: ChoiceNode

func _ready() -> void:
	pressed.connect(_pressed)

func setup(choice_node: ChoiceNode):
	node = choice_node
	refresh()

func refresh():
	#label.text = node.payload.name
	#icon.texture = node.payload.icon
	match node.state:
		ChoiceNode.State.AVAILABLE:
			disabled = false
		ChoiceNode.State.SELECTED:
			disabled = false
		ChoiceNode.State.BLOCKED:
			disabled = true

func _pressed():
	clicked.emit(node)
	
func _to_string() -> String:
	return "choice_node_button"
