extends Node2D

func _ready() -> void:
	print("--- Testing Level Rewards ---")
	
	# 1. Create a dummy skill
	var skill = Skill.new()
	skill.skill_name = "Fireball"
	skill.description = "A fiery attack"
	
	# 2. Create a SkillReward
	var reward = SkillReward.new()
	reward.skill = skill
	reward.pool_category = Defines.PROG_TAG.Arcane
	
	print("Reward Description: ", reward.get_description())
	
	if not RunManager.skill_pools.has(Defines.PROG_TAG.Arcane):
		RunManager.skill_pools[Defines.PROG_TAG.Arcane] = []
		
	var pool_size_before = RunManager.skill_pools[Defines.PROG_TAG.Arcane].size()
	print("Pool size before: ", pool_size_before)
	
	# 3. Apply reward
	reward.apply_reward()
	
	var pool_size_after = RunManager.skill_pools[Defines.PROG_TAG.Arcane].size()
	print("Pool size after: ", pool_size_after)
	
	assert(pool_size_after == pool_size_before + 1)
	
	print("Testing duplicate prevention...")
	reward.apply_reward()
	assert(RunManager.skill_pools[Defines.PROG_TAG.Arcane].size() == pool_size_after)
	
	print("Testing missing skill validation...")
	var bad_reward = SkillReward.new()
	bad_reward.pool_category = Defines.PROG_TAG.Arcane
	bad_reward.apply_reward()
	
	print("--- Rewards Test Successful ---")
	get_tree().quit()
