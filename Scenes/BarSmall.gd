@tool
extends Control

const BORDER_RADIUS := 8

@export_range(0.0, 1.0, 0.01)
var fill_ratio: float = 0.5:
	set(value):
		value = clamp(value, 0.0, 1.0)

		if is_equal_approx(fill_ratio, value):
			return

		fill_ratio = value
		_update_fill()

@onready var clipper: Control = %Clipper
@onready var background_border_shadow: Panel = %BackgroundBorderShadow
@onready var main_border: Panel = %MainBorder
@onready var outside_border_wall: Panel = %OutsideBorderWall
@onready var right_highlitght: Panel = %RightHighlitght

var _styleboxes: Array[StyleBoxFlat] = []
var _last_radius := -1

func _ready():
	var panels: Array[Panel] = [
		background_border_shadow,
		main_border,
		outside_border_wall,
		right_highlitght
	]

	for panel in panels:
		var sb := panel.get_theme_stylebox("panel").duplicate()

		if sb is StyleBoxFlat:
			panel.add_theme_stylebox_override("panel", sb)
			_styleboxes.append(sb)

	_update_fill()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_update_fill()

func _update_fill():
	if !is_node_ready():
		return

	var full_width := size.x

	clipper.position = Vector2.ZERO
	clipper.set_deferred("size", Vector2(
		round(full_width * fill_ratio),
		size.y
	))

	var distance := full_width - clipper.size.x
	var target_radius = max(0, BORDER_RADIUS - distance)

	if target_radius != _last_radius:
		_last_radius = target_radius

		for sb in _styleboxes:
			sb.corner_radius_bottom_right = target_radius
			sb.corner_radius_top_right = target_radius
