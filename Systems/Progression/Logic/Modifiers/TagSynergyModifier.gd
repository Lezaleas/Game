# TagSynergyModifier.gd
# Description: Increase tag2 by tag1 amount, with chance scaling from tag1.
# A concrete Modifier that increases a target tag (scaling_tag_2) by the amount of a source tag (scaling_tag)
# with a success chance that scales based on the source tag's current pressure.
class_name TagSynergyModifier
extends Modifier

func _init() -> void:
	modifier_name = "Tag Synergy"
	desc = "Increase target tag pressure by source tag pressure, with success chance scaling from the source tag."
	hook_type = [Defines.ModifierHook.CALCULATE_TAG_PRESSURE]
	# Default tags to avoid crashes if uninitialized
	scaling_tag = Defines.PROG_TAG.Smithing
	scaling_tag_2 = Defines.PROG_TAG.Crafting
	priority = 0

func execute(hook: Defines.ModifierHook, context: GenerationContext) -> void:
	if hook != Defines.ModifierHook.CALCULATE_TAG_PRESSURE:
		return
	
	var val_tag1 = context.tags.get(scaling_tag, 0.0)
	var roll_chance = val_tag1 * chance
	
	if Utils.chance(roll_chance, RunManager.run_rng):
		var gain = val_tag1 * power
		context.tags[scaling_tag_2] = context.tags.get(scaling_tag_2, 0.0) + gain
		print("TagSynergyModifier: Roll succeeded (chance: ", roll_chance, "%). Increased tag ", Defines.PROG_TAG.keys()[scaling_tag_2], " by ", gain)
