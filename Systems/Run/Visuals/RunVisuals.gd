extends Node2D

@onready var perk_trees: = [%PerkTree0, %PerkTree1, %PerkTree2, %PerkTree3]

func open_perk_tree(hero_id: int) -> void:
	for tree in perk_trees:
		tree.hero = RunManager.heroes[hero_id]
		tree._ready()
