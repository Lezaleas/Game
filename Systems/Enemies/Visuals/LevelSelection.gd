extends Control
class_name LevelSelection

@onready var grid: GridContainer = %GridContainer
@onready var info_panel: LevelInfoPanel = %LevelInfoPanel
@onready var randomize_rewards_btn: Button = %RandomizeRewardsBtn
@onready var increase_quality_btn: Button = %IncreaseQualityBtn
@export var level_card_scene: PackedScene = preload("res://Systems/Enemies/Visuals/LevelCard.tscn")

var current_levels: Array[LevelData] = []

func _ready() -> void:
	randomize_rewards_btn.pressed.connect(_on_randomize_rewards_pressed)
	increase_quality_btn.pressed.connect(_on_increase_quality_pressed)
	refresh(current_levels)

func refresh(levels: Array[LevelData] = []) -> void:
	if not levels: levels = RunManager.levels
	current_levels = levels
	for child in grid.get_children():
		child.queue_free()
	
	for level in levels:
		if level:
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

func _on_randomize_rewards_pressed() -> void:
	var skill_lib: SkillLibrary = Defines.skills
	if not skill_lib or skill_lib.regular_skills.is_empty():
		push_warning("LevelSelection: No skills found in SkillLibrary.")
		print("Randomize Rewards failed: No skills found in SkillLibrary.")
		return
		
	var all_skills = skill_lib.regular_skills
	var all_categories = Defines.PROG_TAG.values()
	
	for level in RunManager.levels:
		if level:
			# Remove previous SkillRewards to prevent infinite stacking
			var new_rewards: Array[LevelReward] = []
			for r in level.rewards:
				if not r is SkillReward:
					new_rewards.append(r)
			level.rewards = new_rewards
			
			var reward = SkillReward.new()
			reward.skill = all_skills.pick_random() as Skill
			reward.pool_category = all_categories.pick_random() as Defines.PROG_TAG
			level.rewards.append(reward)
			print("Added random skill %s to level %s" % [reward.skill.skill_name, level.id])
			
	refresh(RunManager.levels)

func _on_increase_quality_pressed() -> void:
	var count = 0
	for building in RunManager.buildings:
		if building:
			building.quality += 1.0
			print("Increased quality of %s to %f" % [building.building_name, building.quality])
			count += 1
	
	if count == 0:
		push_warning("LevelSelection: No buildings found in RunManager.buildings.")
		print("Increase Quality failed: No buildings found.")
