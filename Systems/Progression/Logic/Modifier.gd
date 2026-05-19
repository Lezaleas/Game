# Modifier.gd
# Base resource type for all generation pipeline modifiers.
# Modifiers subscribe to standardized hooks and mutate the shared GenerationContext.
class_name Modifier
extends Resource

@export var modifier_name: String = ""
@export_multiline var desc: String = "" # Descriptive text for this modifier/skill.

## Holds which kind of hooks it wants to subscribe to. Note that the ability will be called on each
## hooks listed, so for abilities with double effects we need to match each to their correct call
@export var hook_type: Array[Defines.ModifierHook] = []

## the chance of the ability. if it scales from a tag, 1 should mean (1*tag_scaling/100) chance
## otherwise 1 should mean 1/100 chance
@export var chance: float = 1.0
## if the ability isn't random it will probably use power instead. there's no division by 100 here
@export var power: float = 1.0
@export var element: Defines.PROG_ELEMENT # villager skills might have elements they need to activate
@export var scaling_tag: Defines.PROG_TAG # room skills might scale from certain tags
@export var scaling_tag_2: Defines.PROG_TAG
@export var priority: int = 0 # Execution priority; higher values run first.
@export var is_global: bool = false # global skills

var villager: Villager
var room: Room

## Main execution hook called during item generation phases.
## Subclasses must override this to implement custom behavior.
func execute(hook: Defines.ModifierHook, context: GenerationContext) -> void:
	pass
