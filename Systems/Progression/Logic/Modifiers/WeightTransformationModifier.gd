# WeightTransformationModifier.gd
# Description: If assigned to a Fire room, increase generated item weight by 100.
# A concrete Modifier that increases the final item's weight by 100
# when the hosting villager is assigned to a Fire room.
class_name WeightTransformationModifier
extends Modifier

func _init() -> void:
	modifier_name = "Heavyweight Infusion"
	desc = "If assigned to a Fire room, increase generated item weight by 100."
	priority = -50 # Low priority

func execute(hook: Defines.ModifierHook, context: GenerationContext) -> void:
	if hook != Defines.ModifierHook.AFTER_ITEM_GENERATION:
		return
	
	if not context.generated_item:
		return
		
	# Find if this modifier's hosting villager is in a Fire room
	var active = false
	for room in context.building.rooms:
		if room and room.element == Defines.PROG_ELEMENT.Fire:
			for v in room.assigned_villagers:
				if v and (v.modifiers.has(self) or v.traits.has(self)):
					active = true
					break
			if active:
				break
				
	if active:
		context.generated_item.weight += 100
		print("WeightTransformationModifier: Added +100 weight. New weight: ", context.generated_item.weight)
