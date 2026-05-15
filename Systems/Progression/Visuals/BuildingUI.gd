extends PanelContainer
class_name BuildingUI

@onready var name_label = %BuildingName
@onready var pressure_label = %PressureLabel
@onready var room_container = %RoomContainer

var building: Building
var room_ui_scene = preload("res://Systems/Progression/Visuals/RoomUI.tscn")

func setup(p_building: Building) -> void:
	building = p_building
	name_label.text = building.building_name
	
	# Clear and rebuild rooms
	for child in room_container.get_children():
		child.queue_free()
	
	for room in building.rooms:
		var room_ui = room_ui_scene.instantiate()
		room_container.add_child(room_ui)
		room_ui.setup(room)
	
	refresh_pressure()

func refresh_pressure() -> void:
	var pressure = building.get_tag_pressure()
	var text = "Pressure: "
	for tag in pressure:
		text += "[%s: %s] " % [Defines.PROG_TAG.keys()[tag], pressure[tag]]
	pressure_label.text = text
