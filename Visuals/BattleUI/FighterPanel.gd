extends Panel
class_name FighterPanel

var fighter: FighterState
@export var id = 0 as int
@onready var v_box: VBoxContainer = %VBox

var icon = "res://Data/Assets/Sprites/Common/ElementalIcons/Black.tres"
var label = Label.new()
var label2 = Label.new()

func _ready() -> void:
	add_to_group("refresh")

# Called when the node enters the scene tree for the first time.
func refresh_battle_started() -> void:
	v_box.add_child(label)
	v_box.add_child(label2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func refresh(_delta:):
	label.text = "text goes here"
	label2.text = "text goes here then"
	
