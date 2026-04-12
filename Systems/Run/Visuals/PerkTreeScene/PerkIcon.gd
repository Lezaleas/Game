extends Button

@onready var selector: Panel = %Selector
@onready var favorite_selector: Panel = %Favorite
@onready var locked: Panel = %Locked

var favorite := false
var selected := false
var perk: Perk:
	set(val):
		perk = val
		_update_visuals()

func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	EventBus.subscribe("perk_icon_clicked", self )
	
func setup() -> void:
	if perk.tier_index is int and perk.tree_index is int:
		if perk.tier_index < RunManager.heroes[perk.hero_id].perk_trees[perk.tree_index].perk_points:
			locked.visible = false
		else:
			locked.visible = true
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
	EventBus.emit("perk_icon_clicked", self )
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
	
	# The event is emitted BEFORE the clicked icon toggles its state.
	# So 'not data.selected' means it's about to be selected.
	if data.selected: return
	
	# Only respond if this icon is ALREADY selected.
	# If it's not selected, there's nothing to remove anyway.
	if not selected: return
	
	var other: Perk = data.perk
	if not other or not perk: return
	
	# Only clear perks for the same hero
	if perk.hero_id != other.hero_id: return
	
	var same_perk = perk.id == other.id
	var same_tree = perk.tree_index == other.tree_index
	var same_tier = perk.tier_index == other.tier_index
	
	if same_perk or same_tier or same_tree:
		selected = false
		selector.visible = false
		EventBus.emit("request_perk_remove", perk)
