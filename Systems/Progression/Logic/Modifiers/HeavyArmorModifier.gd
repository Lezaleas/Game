# HeavyArmorModifier.gd
# Description: In Fire rooms, increase Armor category generation weight by 25.
# A concrete Modifier that increases heavy armor (Armor category) generation chance by 25
# when activated in a room with the Fire element.
class_name HeavyArmorModifier
extends Modifier

func _init() -> void:
	modifier_name = "Heavy Armor Specialization"
	desc = "In Fire rooms, increase Armor category generation weight by 25."
	priority = 0

func execute(hook: Defines.ModifierHook, context: GenerationContext) -> void:
	if hook != Defines.ModifierHook.CALCULATE_ITEM_WEIGHTS:
		return
	
	if context.building:
		var has_fire_room = false
		for r in context.building.rooms:
			if r and r.element == Defines.PROG_ELEMENT.Fire:
				has_fire_room = true
				break
		if has_fire_room:
			context.item_weights[Defines.EQUIP_TYPE.Armor] = context.item_weights.get(Defines.EQUIP_TYPE.Armor, 0.0) + 25.0
