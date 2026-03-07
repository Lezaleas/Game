extends PerkEffect
class_name AttributePerk

@export var amount: int
@export var attribute: Defines.ATTRIBUTE

func apply(_hero: HeroState) -> void:
	_hero.increase_attribute(amount, attribute)
