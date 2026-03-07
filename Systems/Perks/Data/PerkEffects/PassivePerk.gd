extends PerkEffect
class_name PassivePerk

@export var passive: Skill

func apply(_hero: HeroState) -> void:
	_hero.skills.append(passive)
