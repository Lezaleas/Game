extends Node

@onready var fighter_panel_0: Panel = %FighterIntermissionPanel0
@onready var fighter_panel_1: Panel = %FighterIntermissionPanel1
@onready var fighter_panel_2: Panel = %FighterIntermissionPanel2
@onready var fighter_panel_3: Panel = %FighterIntermissionPanel3
@onready var fighter_panels: Array[Panel]
@onready var skill_inventory: SkillGrid = %SkillInventory


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var intermission_team: Array[HeroState] = [
		load("res://Visuals/Fighters/Hero1.tres") as HeroState,
		load("res://Visuals/Fighters/Hero2.tres") as HeroState,
		load("res://Visuals/Fighters/Hero3.tres") as HeroState,
		load("res://Visuals/Fighters/Hero4.tres") as HeroState,
	]
	var enemy_team: Array[HeroState] = [
		load("res://Visuals/Fighters/Hero5.tres") as HeroState,
		load("res://Visuals/Fighters/Hero6.tres") as HeroState,
		load("res://Visuals/Fighters/Hero7.tres") as HeroState,
		load("res://Visuals/Fighters/Hero8.tres") as HeroState,
	]

	Situation.player_team_data = intermission_team
	Situation.enemy_team_data = enemy_team

	fighter_panels = [fighter_panel_0, fighter_panel_1, fighter_panel_2, fighter_panel_3]
	for i in range(4):
		fighter_panels[i].fighter = Situation.player_team_data[i]
		
	skill_inventory.populate(Situation.skill_library.regular_skills)
	
	%StartBattleButton.pressed.connect(_on_start_battle_button_pressed)
	
	EventBus.subscribe("debug_skills_selected", self, "_on_debug_skills_selected")

func _on_debug_skills_selected(skills: Array[Skill]) -> void:
	skill_inventory.populate(skills)

func _on_start_battle_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/BattleInstance.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_game"): get_tree().quit()
