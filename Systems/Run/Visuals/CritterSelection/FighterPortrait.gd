extends PanelContainer
class_name FighterPortrait

signal portrait_clicked(index: int)
signal critter_dropped(critter: Critter, index: int)
signal portrait_hovered(fighter: HeroState)

@export var index: int = 0
@onready var portrait_texture: TextureRect = $portrait_texture

var hero_state: HeroState

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)

func setup(hero: HeroState, idx: int) -> void:
	hero_state = hero
	index = idx
	portrait_texture.texture = null
	if hero and hero.critter and hero.critter.sprite and hero.critter.sprite.get_frame_count("default") > 0:
		portrait_texture.texture = hero.critter.sprite.get_frame_texture("default", 0)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		portrait_clicked.emit(index)

func _on_mouse_entered() -> void:
	portrait_hovered.emit(hero_state)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Critter

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Critter:
		critter_dropped.emit(data, index)
