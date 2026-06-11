extends PerkEffect
class_name SkillPerk

@export var skill: Skill

func unlock(hero:HeroState) -> void:
	hero.grant_skill(skill)

func remove(hero:HeroState) -> void:
	hero.remove_skill(skill)

## receives a skill and return the skill perk that equips said skill
static func skill_to_perk(skill_to_convert:Skill) -> Perk:
	var perk = Perk.new()
	var skill_perk = SkillPerk.new()
	skill_perk.skill = skill_to_convert
	perk.effects.append(skill_perk)
	perk.id = skill_to_convert.skill_name
	perk.display_name = skill_to_convert.skill_name
	return perk.duplicate(true)
