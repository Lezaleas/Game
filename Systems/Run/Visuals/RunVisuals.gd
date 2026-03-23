extends Node2D

@onready var perk_trees: Array[Node] = [%PerkTree0, %PerkTree1, %PerkTree2, %PerkTree3]
@onready var perk_selection_screen: = %PerkSelectionScreen
@onready var equipment_selection_screen: = %EquipmentSelectionScreen

func open_perk_tree(hero_id: int) -> void:
	equipment_selection_screen.visible = false
	perk_selection_screen.visible = true
	for tree in perk_trees:
		tree.hero = RunManager.heroes[hero_id]
		tree._ready()

func open_equipment_screen() -> void:
	perk_selection_screen.visible = false
	equipment_selection_screen.visible = true
