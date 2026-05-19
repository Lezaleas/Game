class_name Example_Modifier
extends Modifier

# Example_Modifier
# make sure to include a short description. # double tag2 based on tag chance

func _init() -> void:
	modifier_name = "Example Modifier"
	desc = "double your %s tag" %Defines.PROG_TAG.keys()[scaling_tag_2]
	hook_type = [Defines.ModifierHook.CALCULATE_TAG_PRESSURE]
	scaling_tag = Defines.PROG_TAG.Arcane
	scaling_tag_2 = Defines.PROG_TAG.Learning
	priority = 0
	is_global = false

func execute(hook: Defines.ModifierHook, context: GenerationContext) -> void:
	if Utils.chance(context.tags[scaling_tag_2] * chance, RunManager.run_rng):
		context.tags[scaling_tag] *= 2
