extends VBoxContainer

var hero: HeroState
@export var id: int
var tree: PerkTree

const PERK_ICON = preload("res://Systems/Run/Visuals/PerkTreeScene/PerkIcon.tscn")

func _ready() -> void:
	if hero and hero.perk_trees.size() > id:
		hero.update_perk_points()
		tree = hero.perk_trees[id]
		render()

func render() -> void:
	add_theme_constant_override("separation", 24)
	for child in get_children():
		child.queue_free()
	
	if not tree: return
	
	for tier in tree.tiers:
		var row = HBoxContainer.new()
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_theme_constant_override("separation", 16)
		add_child(row)
		for perk in tier.perks:
			var icon = PERK_ICON.instantiate()
			row.add_child(icon)
			icon.perk = perk
			icon.setup()
