extends Node2D
class_name BattleView

@onready var debug = %DebugOverlay
@onready var state = Situation.battle

func _ready() -> void:
	set_process(false)

func on_battle_started():
	var fighter_scene = preload("res://Visuals/Battle/FighterView.tscn")
	for fighter_state in Situation.fighters:
		var fighter_view = fighter_scene.instantiate()
		fighter_view.id = fighter_state.id
		fighter_view.name = "FighterView" + str(fighter_state.id)
		add_child(fighter_view)
	
	for node in get_tree().get_nodes_in_group("refresh"):
		if node.has_method("refresh_battle_started"):
			node.refresh_battle_started()
	
	set_process(true)

func _process(delta: float) -> void:
	debug.set_debug_text("FPS: " + str(Engine.get_frames_per_second()))
	debug.append_debug_text("Turn: " + str(Situation.battle.turn))
	for node in get_tree().get_nodes_in_group("refresh"):
		node.refresh(delta)
