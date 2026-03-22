extends Button

@onready var selector: Panel = %Selector
@onready var favorite_selector: Panel = %Favorite

var favorite: = false
var selected: = false
var perk: Perk:
	set(val):
		perk = val
		_update_visuals()

func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	EventBus.subscribe("perk_icon_clicked", self)
	
func setup() -> void:
	if perk.unlocked:
		selected = true
		selector.visible = true
	if perk.favorited:
		favorite = true
		favorite_selector.visible = true
	_update_visuals()

func _update_visuals() -> void:
	if not perk or not is_inside_tree(): return
	%SkillNameLabel.text = perk.id
	# Here we would update the visual icon, e.g., setting a TextureRect
	# For now we just store it as requested.

func _on_mouse_entered() -> void:
	if perk:
		EventBus.emit("skill_hovered", perk)
	else:
		EventBus.emit("skill_hovered", null)

func _pressed() -> void:
	EventBus.emit("perk_icon_clicked", self)
	selected = !selected
	selector.visible = selected
	if selected:
		EventBus.emit("request_perk_unlock", perk)
	else:
		EventBus.emit("request_perk_remove", perk)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			favorite = !favorite
			favorite_selector.visible = favorite
			perk.favorited = favorite

func on_perk_icon_clicked(data) -> void:
	if data == self: return
	
	var other: Perk = data.perk
	var same_perk = perk.id == other.id
	var same_tier = perk.perk_tier.index == other.perk_tier.index
	var same_tree = perk.perk_tree == other.perk_tree
	if same_perk or same_tier or same_tree:
		selected = false
		selector.visible = false
		EventBus.emit("request_perk_remove", perk)
