extends Node
class_name CritterSelectionController

@export var fighter_container: Container
@export var critter_container: Container
@export var info_panel: CritterInfoPanel

var fighter_portrait_scene = preload("res://Systems/Run/Visuals/CritterSelection/FighterPortrait.tscn")
var critter_portrait_scene = preload("res://Systems/Run/Visuals/CritterSelection/CritterPortrait.tscn")

var selected_critter: Critter = null

func _ready() -> void:
	call_deferred("populate_ui")

func populate_ui() -> void:
	if not fighter_container or not critter_container or not info_panel:
		push_warning("CritterSelectionController: Missing container references")
		return

	# Clear existing
	for child in fighter_container.get_children():
		child.queue_free()
	for child in critter_container.get_children():
		child.queue_free()
		
	# Add Fighters
	for i in range(RunManager.heroes.size()):
		var hero = RunManager.heroes[i]
		var f_portrait = fighter_portrait_scene.instantiate() as FighterPortrait
		fighter_container.add_child(f_portrait)
		f_portrait.setup(hero, i)
		f_portrait.portrait_hovered.connect(_on_fighter_hovered)
		f_portrait.portrait_clicked.connect(_on_fighter_clicked)
		f_portrait.critter_dropped.connect(_on_critter_dropped)

	# Add Critters
	for critter in RunManager.critters:
		var c_portrait = critter_portrait_scene.instantiate() as CritterPortrait
		critter_container.add_child(c_portrait)
		c_portrait.setup(critter)
		c_portrait.portrait_hovered.connect(_on_critter_hovered)
		c_portrait.portrait_clicked.connect(_on_critter_clicked)

	info_panel.clear()

func _on_fighter_hovered(fighter: HeroState) -> void:
	info_panel.display_fighter(fighter)

func _on_critter_hovered(critter: Critter) -> void:
	info_panel.display_critter(critter)

func _on_critter_clicked(critter: Critter) -> void:
	selected_critter = critter
	print("Selected critter: ", critter.id)

func _on_fighter_clicked(index: int) -> void:
	if selected_critter:
		assign_critter_to_fighter(selected_critter, index)
		selected_critter = null

func _on_critter_dropped(critter: Critter, index: int) -> void:
	assign_critter_to_fighter(critter, index)

func assign_critter_to_fighter(critter: Critter, fighter_index: int) -> void:
	var hero = RunManager.heroes[fighter_index]
	critter.equip_to_hero(hero)
	print("Assigned critter ", critter.id, " to fighter ", fighter_index)
	# Refresh visuals
	populate_ui()
