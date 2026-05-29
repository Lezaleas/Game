extends LevelReward
class_name SkillReward

@export var skill: Skill
@export var pool_category: Defines.PROG_TAG

func apply_reward() -> void:
	if skill == null:
		push_warning("SkillReward: skill is null. Cannot apply reward.")
		print("SkillReward failed: skill is null")
		return

	if not RunManager.skill_pools.has(pool_category):
		push_warning("SkillReward: RunManager.skill_pools does not have category %s." % pool_category)
		print("SkillReward failed: invalid pool category %s" % pool_category)
		return

	var pool: Array = RunManager.skill_pools[pool_category]
	
	if pool.has(skill):
		print("SkillReward: Skill %s already in pool %s. Skipping." % [skill.skill_name, Defines.PROG_TAG.keys()[pool_category]])
		return

	pool.append(skill)
	print("SkillReward applied: Added skill %s to pool %s" % [skill.skill_name, Defines.PROG_TAG.keys()[pool_category]])

func get_description() -> String:
	if skill:
		return "%s Skill (%s)" % [skill.skill_name, Defines.PROG_TAG.keys()[pool_category]]
	return "Empty Skill Reward"
