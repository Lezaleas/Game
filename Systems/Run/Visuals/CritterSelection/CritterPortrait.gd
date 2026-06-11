extends PanelContainer
class_name CritterPortrait

signal portrait_clicked(critter: Critter)
signal portrait_hovered(critter: Critter)

@onready var portrait_texture: TextureRect = $portrait_texture

var critter_state: Critter

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)

func setup(critter: Critter) -> void:
	critter_state = critter
	if critter and critter.sprite and critter.sprite.get_frame_count("default") > 0:
		portrait_texture.texture = critter.sprite.get_frame_texture("default", 0)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		portrait_clicked.emit(critter_state)

func _on_mouse_entered() -> void:
	portrait_hovered.emit(critter_state)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not critter_state:
		return null
	
	# Create visual feedback for drag
	var preview = Control.new()
	var tex = TextureRect.new()
	if critter_state.sprite and critter_state.sprite.get_frame_count("default") > 0:
		tex.texture = critter_state.sprite.get_frame_texture("default", 0)
	tex.custom_minimum_size = Vector2(64, 64)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.add_child(tex)
	# Center the preview
	tex.position = -tex.custom_minimum_size / 2.0
	
	set_drag_preview(preview)
	return critter_state
