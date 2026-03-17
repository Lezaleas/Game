extends CanvasLayer

@onready var label_blue = %LabelBlue
@onready var label_red = %LabelRed

const CLASH_BAR_SCENE = preload("res://Systems/Battle/Visuals/ClashBar.tscn")
const DASH_IN_DURATION = 0.2
const DASH_OUT_DURATION = 0.2
const HIT_FREEZE_DURATION = 0.1
const DASH_DISTANCE = 100.0

func _ready() -> void:
	visible = false

func start_clash(data: Dictionary) -> void:
	var blue = data.blue as FighterState
	var red = data.red as FighterState
	
	# Setup UI
	label_blue.text = "%d" % data.blue_str
	label_red.text = "%d" % data.red_str
	visible = true
	
	var blue_view = _get_fighter_view(blue.id)
	var red_view = _get_fighter_view(red.id)
	
	if not blue_view or not red_view: return

	blue_view.play_clashing_animation()
	red_view.play_clashing_animation()
	
	if data.blue_str > data.red_str:
		_dash_winner(blue_view, red_view, 1)
	elif data.red_str > data.blue_str:
		_dash_winner(red_view, blue_view, -1)
	
	label_blue.position = blue_view.position + Vector2(-200, -20)
	label_red.position = red_view.position + Vector2(200, -20)
	
	var bar = CLASH_BAR_SCENE.instantiate()
	add_child(bar)
	
	# Calculate vector between fighters
	var start_pos = blue_view.position + Vector2(20, 0)
	var end_pos = red_view.position + Vector2(-20, 0)
	var diff = end_pos - start_pos
	
	# Setup bar dimensions and rotation
	bar.size = Vector2(diff.length(), 10)
	bar.pivot_offset = Vector2(0, 5) # Pivot at vertical center left
	bar.rotation = diff.angle()
	bar.position = start_pos - bar.pivot_offset
	
	var total_str = data.blue_str + data.red_str
	bar.value = float(data.blue_str) / float(total_str) if total_str > 0 else 0.5
	
	# Wait - slightly longer than the DASH durations to ensure sequence completes
	await get_tree().create_timer(0.3).timeout
	visible = false
	bar.queue_free()

func _get_fighter_view(id: int) -> FighterView:
	return Situation.fighters[id].view

func _dash_winner(winner_view: FighterView, loser_view:FighterView, blue_won: int) -> void:
	# Ensure we use a clean tween and kill any overlapping ones on this fighter
	var tween = create_tween()
	var orig_pos = winner_view.position
	#var dash_to = orig_pos + Vector2(DASH_DISTANCE, 0) * blue_won
	var dash_to = loser_view.position
	for fighter in Situation.fighters:
		fighter.view.lock_movement()
	EventBus.emit("request_pause", true)
	
	# Dash in
	tween.tween_property(winner_view, "position", dash_to,
		DASH_IN_DURATION / Situation.anim_speed) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(DASH_IN_DURATION + HIT_FREEZE_DURATION).timeout
	tween = create_tween()
	var winner_log_pos = Vector2(winner_view.fighter_state.position_x, winner_view.fighter_state.position_y)
	
	# Return with elasticity
	tween.tween_property(winner_view, "position", winner_log_pos,
		DASH_OUT_DURATION / Situation.anim_speed) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
		
	await get_tree().create_timer(DASH_OUT_DURATION).timeout
		
	for fighter in Situation.fighters:
		fighter.view.unlock_movement()
	EventBus.emit("request_pause", false)
