@tool
extends Control

const BORDER_RADIUS := 8

@export_range(0.0, 1.0, 0.01)
var fill_ratio: float = 0.5:
	set(value):
		fill_ratio = clamp(value, 0.0, 1.0)
		_update_fill()


@onready var clipper: Control = %Clipper
@onready var background_border_shadow: Panel = %BackgroundBorderShadow
@onready var main_border: Panel = %MainBorder
@onready var outside_border_wall: Panel = %OutsideBorderWall
@onready var right_highlitght: Panel = %RightHighlitght


func _ready():
	_update_fill()


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_update_fill()


func _update_fill():
	if !is_node_ready():
		return
	
	if clipper == null:
		return

	var full_width = size.x

	clipper.position = Vector2.ZERO
	clipper.size.y = size.y
	clipper.size.x = round(full_width * fill_ratio)

	# Distance remaining to right edge
	var distance = full_width - clipper.size.x

	# Convert into radius
	var target_radius = max(
		0,
		BORDER_RADIUS - distance
	)

	# Unique stylebox instance
	var panels: = [background_border_shadow,main_border,outside_border_wall,right_highlitght]
	for panel in panels:
		var stylebox = panel.get_theme_stylebox("panel").duplicate()

		if stylebox is StyleBoxFlat:
			print(target_radius)
			stylebox.corner_radius_bottom_right = int(target_radius)
			stylebox.corner_radius_top_right = int(target_radius)

			panel.add_theme_stylebox_override(
				"panel",
				stylebox
			)
