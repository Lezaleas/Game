extends PerkEffect
class_name SkillPerk

@export var skill: Skill

func apply(_hero: HeroState) -> void:
	_hero.skills.append(skill)
