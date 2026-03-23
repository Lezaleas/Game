class_name EquipmentSlot
extends Button

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_name: Label = %ItemName

var equipment: EquipmentState
var index: int = -1
var source_array: Array[EquipmentState]
var equip_type_restriction: int = -1 # -1 means no restriction, otherwise from Defines.EQUIP_TYPE

func set_selected(selected: bool) -> void:
	if selected:
		modulate = Color(1.5, 1.5, 1.0) # Brighten slightly
	else:
		modulate = Color(1, 1, 1)

func set_equipment(item: EquipmentState) -> void:
	equipment = item
	if equipment:
		item_name.text = equipment.display_name
		item_icon.texture = equipment.icon
		item_icon.show()
		item_name.show()
	else:
		item_icon.hide()
		item_name.text = "---"
		if equip_type_restriction != -1:
			item_name.text += " (" + str(Defines.EQUIP_TYPE.keys()[equip_type_restriction]) + ")"

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if equipment:
			EventBus.emit("equipment_hovered", equipment)
		else:
			EventBus.emit("equipment_hovered", null)

func _pressed() -> void:
	EventBus.emit("equipment_slot_clicked", self)
