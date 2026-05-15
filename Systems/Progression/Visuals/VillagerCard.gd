extends PanelContainer
class_name VillagerCard

@onready var name_label = %NameLabel
@onready var tags_label = %TagsLabel

var villager: Villager
var selected: bool = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func setup(p_villager: Villager) -> void:
	villager = p_villager
	name_label.text = villager.name
	
	var tag_text = ""
	for tag in villager.tags:
		tag_text += "%s: %s\n" % [Defines.PROG_TAG.keys()[tag], villager.tags[tag]]
	tags_label.text = tag_text

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview = self.duplicate()
	preview.modulate.a = 0.5
	set_drag_preview(preview)
	
	# Return the villager object as drag data
	return villager

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Signal selection to the main screen
			EventBus.emit("villager_selected", villager)
			# DO NOT accept_event() here, or it will block the drag-and-drop system
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			# Move to reserve instantly
			ProgressionManager.move_to_reserve(villager)
			EventBus.emit("progression_updated", {})
			accept_event()

func set_selected(p_selected: bool) -> void:
	selected = p_selected
	if selected:
		modulate = Color(1.5, 1.5, 1.5) # Slight highlight
	else:
		modulate = Color(1, 1, 1)

func _on_mouse_entered() -> void:
	EventBus.emit("progression_hover", villager)

func _on_mouse_exited() -> void:
	# Only clear if we were the ones being hovered
	pass # InfoPanel handles its own clearing or we can emit null
