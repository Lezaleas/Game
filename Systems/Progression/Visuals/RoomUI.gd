extends PanelContainer
class_name RoomUI

@onready var name_label = %RoomName
@onready var villager_container = %VillagerContainer

var room: Room
var villager_card_scene = preload("res://Systems/Progression/Visuals/VillagerCard.tscn")

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func setup(p_room: Room) -> void:
	room = p_room
	name_label.text = room.room_name
	refresh()

func refresh() -> void:
	# Clear existing cards
	for child in villager_container.get_children():
		child.queue_free()
	
	# Add current villagers
	if not room.assigned_villager: return
	var card = villager_card_scene.instantiate()
	villager_container.add_child(card)
	card.setup(room.assigned_villager)
	
	# Check for selection
	if get_tree().current_scene.has_node("%ProgressionScreen"):
		var screen = get_tree().current_scene.get_node("%ProgressionScreen")
		if screen.selected_villager == room.assigned_villager:
			card.set_selected(true)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Villager

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var villager = data as Villager
	ProgressionManager.assign_villager_to_room(villager, room)
	
	# Global refresh signal (could be an event)
	EventBus.emit("progression_updated", {})

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Signal that we were clicked (could be a drop target for click-to-move)
			EventBus.emit("room_clicked", room)
			accept_event()

func _on_mouse_entered() -> void:
	EventBus.emit("progression_hover", room)

func _on_mouse_exited() -> void:
	pass
