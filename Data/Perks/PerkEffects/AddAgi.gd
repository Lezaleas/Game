extends PerkEffect
class_name PerkEffectAddAgi

# Increases the character's Agility base stat by a flat amount.
@export var amount: int = 3

func apply(character) -> void:
	character.attributes[Defines.ATTRIBUTE.Agi].increase_base(amount)
