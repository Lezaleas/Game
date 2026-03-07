extends Node2D
class_name BattleView

@onready var debug = %DebugOverlay
@onready var state = Situation.battle
@onready var clashvisuals: Node = %ClashVisuals

var clash_visuals_list: Array = []
var next_clash_index: int = 0

func _ready() -> void:
	EventBus.subscribe("battle_action_clash_started", self, "_on_clash_started")
	set_process(false)
	for child in clashvisuals.get_children():
		clash_visuals_list.append(child)

func _on_clash_started(data: Dictionary) -> void:
	var clash_visual = clash_visuals_list[next_clash_index]
	clash_visual.start_clash(data)
	next_clash_index = (next_clash_index + 1) % clash_visuals_list.size()

func on_battle_started():
	var fighter_scene = preload("res://Systems/Battle/Visuals/FighterView.tscn")
	for fighter_state in Situation.fighters:
		var fighter_view = fighter_scene.instantiate()
		fighter_view.id = fighter_state.id
		fighter_view.name = "FighterView" + str(fighter_state.id)
		add_child(fighter_view)
		fighter_state.view = fighter_view
	for node in get_tree().get_nodes_in_group("refresh"):
		if node.has_method("refresh_battle_started"):
			node.refresh_battle_started()
	
	set_process(true)

func _process(delta: float) -> void:
	debug.set_debug_text("FPS: " + str(Engine.get_frames_per_second()))
	debug.append_debug_text("Turn: " + str(Situation.battle.turn))
	for node in get_tree().get_nodes_in_group("refresh"):
		node.refresh(delta)
