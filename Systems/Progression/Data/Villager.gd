extends Resource
class_name Villager

@export var name: String = "Unknown Villager"
@export_multiline var description: String = ""

@export var tags: Dictionary = {} # PROG_TAG (str) -> Pressure (int)
@export var method: Defines.PROG_METHOD = Defines.PROG_METHOD.Precise
@export var personality: Defines.PROG_PERSONALITY = Defines.PROG_PERSONALITY.Stubborn

@export var modifiers: Array[Modifier] = []
@export var traits: Array[Modifier] = []
