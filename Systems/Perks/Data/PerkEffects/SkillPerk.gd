extends PerkEffect
class_name SkillPerk

@export var skill: Skill

func unlock(hero:HeroState) -> void:
	hero.grant_skill(skill)

func remove(hero:HeroState) -> void:
	hero.remove_skill(skill)
