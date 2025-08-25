extends Node2D
class_name BattleView

@onready var state = %State
@onready var debug = %DebugOverlay

func on_battle_started():
	var fighter_scene = preload("res://Visuals/Battle/FighterView.tscn")
	for fighter_state in state.all_fighters:
		var fighter_view = fighter_scene.instantiate()
		fighter_state.fighter_view = fighter_view
		fighter_view.fighter_state = fighter_state
		fighter_view.id = fighter_state.id
		fighter_view.name = "FighterView" + str(fighter_state.id)
		add_child(fighter_view)

func _process(_delta: float) -> void:
	debug.set_debug_text("FPS: " + str(Engine.get_frames_per_second()))
	debug.append_debug_text("Turn: " + str(%State.turn_number))
