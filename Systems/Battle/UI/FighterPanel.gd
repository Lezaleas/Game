extends Panel

var fighter: FighterState
@export var id = 0 as int
@onready var v_box: VBoxContainer = %VBox

var icon = Defines.icons.default_icon
var label = Label.new()
var label2 = Label.new()
var label3 = Label.new()

func _ready() -> void:
	add_to_group("refresh")

# Called when the node enters the scene tree for the first time
func refresh_battle_started() -> void:
	fighter = Situation.fighters[id]
	v_box.add_child(label)
	v_box.add_child(label2)
	v_box.add_child(label3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func refresh(_delta: ):
	label.text = ""
	if fighter.skills:
		for skill in fighter.skills:
			if skill.show_to_player:
				label.text += str(skill)
				label.text += "\n"
	label2.text = ""
	for x in range(4):
		var attribute = fighter.attributes[x]
		label2.text += (str(int(attribute.current)))
		label2.text += " - "
	label2.text += str(fighter.stamina)
	var buffs = fighter.buffs.buffs
	if buffs:
		for buff in buffs:
			label3.text = ""
			label3.text += (str(buffs[buff]) + "\n")
