extends Node
class_name EnemyToPerkTree

## Receives an enemydata resource and returns it's skills as a perk tree
static func Convert(enemy:EnemyData) -> PerkTree:
	var perk_tree: = PerkTree.new()
	var skills: Array[Skill] = enemy.skills.duplicate(true)
	var perk_tiers = perk_tree.tiers
	for skill in skills:
		if not skill: continue
		var tier = PerkTier.new()
		var perk = Perk.new()
		var skill_perk = SkillPerk.new()
		skill_perk.skill = skill
		perk.effects.append(skill_perk)
		perk.id = skill.skill_name
		perk.display_name = skill.skill_name
		tier.perks.append(perk)
		perk_tiers.append(tier)
	return perk_tree
