# PreciseSmithingModifier.gd
# Description: When Smithing pressure is 10 or greater, increase Pwr perk roll weight by 15.
# A concrete Modifier that increases Pwr perk focus/attributes roll weight by 15
# when Smithing pressure reaches at least 10.
class_name PreciseSmithingModifier
extends Modifier

func _init() -> void:
	modifier_name = "Precise Smithing"
	desc = "When Smithing pressure is 10 or greater, increase Power perk roll weight by 15."
	priority = 10 # Higher priority

func execute(hook: Defines.ModifierHook, context: GenerationContext) -> void:
	if hook != Defines.ModifierHook.BEFORE_PERK_ROLL:
		return
	
	var smithing = context.tags.get(Defines.PROG_TAG.Smithing, 0.0)
	if smithing >= 10.0:
		# Boost Power (Attribute Index 0) roll weight
		context.perk_weights[0] = context.perk_weights.get(0, 0.0) + 15.0
