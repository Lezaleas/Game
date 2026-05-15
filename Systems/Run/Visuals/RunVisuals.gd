extends Node2D

@onready var perk_trees: Array[Node] = [%PerkTree0, %PerkTree1, %PerkTree2, %PerkTree3]
@onready var perk_selection_screen := %PerkSelectionScreen
@onready var equipment_selection_screen := %EquipmentSelectionScreen
@onready var level_selection_screen := %LevelSelectionScreen
@onready var progression_screen := %ProgressionScreen

@onready var all_screens: Array[Control] = [
	perk_selection_screen,
	equipment_selection_screen,
	level_selection_screen,
	progression_screen
]

func _ready() -> void:
	pass

func hide_all_screens() -> void:
	for screen in all_screens:
		screen.visible = false

func open_perk_tree(hero_id: int) -> void:
	hide_all_screens()
	perk_selection_screen.visible = true
	for tree in perk_trees:
		tree.hero = RunManager.heroes[hero_id]
		tree._ready()

func open_equipment_screen() -> void:
	hide_all_screens()
	equipment_selection_screen.visible = true
	equipment_selection_screen.refresh()

func open_level_selection_screen() -> void:
	hide_all_screens()
	level_selection_screen.visible = true
	level_selection_screen.refresh()

func open_progression_screen() -> void:
	hide_all_screens()
	progression_screen.visible = true
	progression_screen.refresh()

func open_save_load_screen() -> void:
	# Note: save_load_screen reference was commented out in original code
	# but for consistency we should probably add it to all_screens if implemented
	hide_all_screens()
	# save_load_screen.visible = true

#func open_save_load_screen() -> void:
	#perk_selection_screen.visible = false
	#equipment_selection_screen.visible = false
	#level_selection_screen.visible = false
	#save_load_screen.visible = true
