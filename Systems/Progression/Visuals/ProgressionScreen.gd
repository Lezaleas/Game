extends Control
class_name ProgressionScreen

@onready var building_container = %BuildingContainer
@onready var reserve_container = %ReserveContainer
@onready var results_label = %ResultsLabel
@onready var produce_button = %ProduceButton
@onready var skill_pools_button = %SkillPoolsButton
@onready var skill_pools_panel = %SkillPoolsPanel

var building_ui_scene = preload("res://Systems/Progression/Visuals/BuildingUI.tscn")
var villager_card_scene = preload("res://Systems/Progression/Visuals/VillagerCard.tscn")

var selected_villager: Villager = null

func _ready() -> void:
	EventBus.subscribe("progression_updated", self)
	EventBus.subscribe("villager_selected", self)
	EventBus.subscribe("room_clicked", self)
	
	produce_button.pressed.connect(_on_produce_pressed)
	skill_pools_button.pressed.connect(_on_skill_pools_pressed)
	
	# Handle drop on reserve
	reserve_container.gui_input.connect(_on_reserve_input)

func refresh() -> void:
	# Refresh Buildings
	for child in building_container.get_children():
		child.queue_free()
	
	for building in RunManager.buildings:
		var building_ui = building_ui_scene.instantiate()
		building_container.add_child(building_ui)
		building_ui.setup(building)
	
	# Refresh Reserve
	for child in reserve_container.get_children():
		child.queue_free()
	
	for villager in RunManager.reserve_villagers:
		var card = villager_card_scene.instantiate()
		reserve_container.add_child(card)
		card.setup(villager)
		if villager == selected_villager:
			card.set_selected(true)


func on_villager_selected(villager: Villager) -> void:
	if selected_villager == villager:
		selected_villager = null
	else:
		if selected_villager:
			ProgressionManager.swap_villagers(selected_villager, villager)
			selected_villager = null
			refresh()
			return
		else:
			selected_villager = villager
	
	# Instead of refresh(), just update highlights to preserve node instances
	# for the drag-and-drop system.
	_update_highlights()

func _update_highlights() -> void:
	# Update cards in buildings
	for building_ui in building_container.get_children():
		for room_ui in building_ui.room_container.get_children():
			for card in room_ui.villager_container.get_children():
				card.set_selected(card.villager == selected_villager)
	
	# Update cards in reserve
	for card in reserve_container.get_children():
		card.set_selected(card.villager == selected_villager)

func on_room_clicked(room: Room) -> void:
	if selected_villager:
		ProgressionManager.assign_villager_to_room(selected_villager, room)
		selected_villager = null
		refresh()

func on_progression_updated(_data) -> void:
	refresh()

func _on_produce_pressed() -> void:
	var results = ProgressionManager.produce_items()
	results_label.text = "\n".join(results)

func _on_skill_pools_pressed() -> void:
	skill_pools_panel.display()

# Reserve area drop handling
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Villager

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var villager = data as Villager
	ProgressionManager.move_to_reserve(villager)
	refresh()

func _on_reserve_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if selected_villager:
				ProgressionManager.move_to_reserve(selected_villager)
				selected_villager = null
				refresh()
