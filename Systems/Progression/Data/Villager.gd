extends Resource
class_name Villager

# The user rule for skills mentioned including a description.
# While not a skill, we'll follow a similar pattern for clarity.
@export var name: String = "Unknown Villager"
@export_multiline var description: String = ""

@export var tags: Dictionary = {} # PROG_TAG (str) -> Pressure (int)
@export var method: Defines.PROG_METHOD = Defines.PROG_METHOD.Precise
@export var personality: Defines.PROG_PERSONALITY = Defines.PROG_PERSONALITY.Stubborn

# Passives will be implemented later, possibly as scripts or sub-resources.
@export var passive_script: GDScript

@export var modifiers: Array[Modifier] = []
@export var traits: Array[Modifier] = []
