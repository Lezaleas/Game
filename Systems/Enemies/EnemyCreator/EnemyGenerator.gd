@tool
extends EditorScript

# Set this to the path of the template you want to generate enemies from
const TEMPLATE_PATH = "res://Systems/Enemies/EnemyCreator/8.tres"
const TARGET_DIR = "res://Systems/Enemies/EnemyData/"

func _run():
	var template = ResourceLoader.load(TEMPLATE_PATH) as EnemyTemplate
	if not template:
		push_warning("Failed to load template at " + TEMPLATE_PATH)
		print("Failed to load template at ", TEMPLATE_PATH)
		return
		
	for stage in range(4):
		_generate_stage_enemy(template, stage)

func _generate_stage_enemy(template: EnemyTemplate, stage: int):
	var enemy_id = template.get("id_" + str(stage))
	if enemy_id == null or enemy_id == "":
		push_warning("Skipping stage %d because id is empty" % stage)
		print("Skipping stage %d because id is empty" % stage)
		return
		
	var target_dir = TARGET_DIR + "Stage" + str(stage) + "/"
	# Ensure the directory exists
	var dir = DirAccess.open(TARGET_DIR)
	if dir == null:
		push_warning("Failed to open target directory: " + TARGET_DIR)
		print("Failed to open target directory: " + TARGET_DIR)
		return
		
	if not dir.dir_exists("Stage" + str(stage)):
		dir.make_dir("Stage" + str(stage))
		
	var target_path = target_dir + enemy_id + ".tres"
	
	var enemy: EnemyData
	if ResourceLoader.exists(target_path):
		enemy = ResourceLoader.load(target_path)
		print("Updating existing enemy at: ", target_path)
	else:
		enemy = EnemyData.new()
		print("Creating new enemy at: ", target_path)
		
	enemy.id = enemy_id
	enemy.sprite = template.get("sprite_" + str(stage))
	
	# Calculate attributes
	var base_power = template.STAGE_BASE_POWER[stage]
	var attr_pow_mult = template.ATTRIBUTE_MULTIPLIER[template.attribute_pow]
	var attr_spi_mult = template.ATTRIBUTE_MULTIPLIER[template.attribute_spi]
	var attr_wis_mult = template.ATTRIBUTE_MULTIPLIER[template.attribute_wis]
	var attr_agi_mult = template.ATTRIBUTE_MULTIPLIER[template.attribute_agi]
	
	if enemy.attributes_base.size() < 11:
		enemy.attributes_base.resize(11)
		enemy.attributes_base.fill(0)
		
	# Based on Defines.ATTRIBUTE: Pwr = 0, Spi = 1, Wis = 2, Agi = 3
	enemy.attributes_base[0] = int(base_power * attr_pow_mult)
	enemy.attributes_base[1] = int(base_power * attr_spi_mult)
	enemy.attributes_base[2] = int(base_power * attr_wis_mult)
	enemy.attributes_base[3] = int(base_power * attr_agi_mult)
	
	# Gather skills and passives for this stage
	var active_skills: Array[Skill] = []
	var passives: Array[Skill] = []
	
	for i in range(stage + 1):
		var skill = template.get("skill_" + str(i))
		if skill != null:
			active_skills.append(skill)
			
		var passive = template.get("passive_" + str(i))
		if passive != null:
			passives.append(passive)
			
	# Pad arrays to exactly 4 slots to match EnemyData's expected size
	while active_skills.size() < 4:
		active_skills.append(null)
	while passives.size() < 4:
		passives.append(null)
		
	# Truncate if there are more than 4 skills for some reason
	if active_skills.size() > 4:
		active_skills.resize(4)
	if passives.size() > 4:
		passives.resize(4)
		
	enemy.skills = active_skills
	enemy.passives = passives
	
	# Force an icon update if the method exists
	if enemy.has_method("_update_icon"):
		enemy._update_icon()
	
	var err = ResourceSaver.save(enemy, target_path)
	if err != OK:
		push_warning("Failed to save enemy at %s (Error code: %d)" % [target_path, err])
		print("Failed to save enemy at %s (Error code: %d)" % [target_path, err])
	else:
		print("Successfully saved enemy at ", target_path)
