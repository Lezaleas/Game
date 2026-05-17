# Modifier.gd
# Base resource type for all generation pipeline modifiers.
# Modifiers subscribe to standardized hooks and mutate the shared GenerationContext.
class_name Modifier
extends Resource

@export var modifier_name: String = ""
@export_multiline var desc: String = "" # Descriptive text for this modifier/skill.
@export var priority: int = 0 # Execution priority; higher values run first.
@export var is_global: bool = false

## Main execution hook called during item generation phases.
## Subclasses must override this to implement custom behavior.
func execute(hook: Defines.ModifierHook, context: GenerationContext) -> void:
	pass
