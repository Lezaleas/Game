extends RichTextLabel
class_name ManaLabel

var mana_reservoir: ReservoirState
@export var id = 0 as int
var icon = Defines.icons.default_icon
var current: String
var mult: String

func _ready() -> void:
	add_to_group("refresh")

# Called when the node enters the scene tree for the first time.
func refresh_battle_started() -> void:
	mana_reservoir = Situation.reservoirs[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func refresh(_delta:):
	current = str(int(mana_reservoir.current_mana))
	mult = str(int(round(mana_reservoir.mult * 100))) + "%"
	text = "[img]" + icon.resource_path + "[/img]" + current + " - " + mult
