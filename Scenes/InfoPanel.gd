extends PanelContainer
class_name InfoPanel

## Reusable RPG info panel with soft shadow, dual pop-out borders, and clean spacing.
## Add children to the Content VBoxContainer to populate.

# --- Customization exports ---
@export var enable_hover_animation := true

var _base_scale: Vector2

func _ready() -> void:
	_base_scale = scale
	if enable_hover_animation:
		mouse_entered.connect(_on_mouse_entered)
		mouse_exited.connect(_on_mouse_exited)


# --- Hover / Focus Micro-Animation ---

func _on_mouse_entered() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self , "scale", _base_scale * 1.02, 0.12)


func _on_mouse_exited() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self , "scale", _base_scale, 0.12)
