extends Control
class_name LevelSelection

@onready var grid: GridContainer = %GridContainer
@onready var info_panel: LevelInfoPanel = %LevelInfoPanel
@export var level_card_scene: PackedScene = preload("res://Systems/Enemies/Visuals/LevelCard.tscn")

func _ready() -> void:
	refresh()

func refresh() -> void:
	for child in grid.get_children():
		child.queue_free()
	
	var levels = [
		load("res://Systems/Enemies/LevelData/Level0.tres"),
		load("res://Systems/Enemies/LevelData/Level1.tres"),
		load("res://Systems/Enemies/LevelData/Level2.tres"),
		load("res://Systems/Enemies/LevelData/Level3.tres"),
	]
	
	for level in levels:
		var card = level_card_scene.instantiate() as LevelCard
		grid.add_child(card)
		card.setup(level)
		card.selected.connect(_on_level_selected)
		card.hovered.connect(_on_level_hovered)

func _on_level_hovered(data: LevelData) -> void:
	info_panel.display(data)

func _on_level_selected(data: LevelData) -> void:
	Situation.level_data = data
	Situation.player_team_data = RunManager.heroes
	get_tree().change_scene_to_file("res://Systems/Battle/Logic/BattleInstance.tscn")
