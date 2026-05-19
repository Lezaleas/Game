class_name GenerationContext
extends RefCounted

var building: Building
var villagers: Array[Villager] = []
var global_modifiers: Array[Modifier] = []

# Numeric pressure values for all tags (Defines.PROG_TAG (int) -> Pressure (float/int))
var tags: Dictionary = {}
# Category weights for rolling base item types (Defines.EQUIP_TYPE (int) -> Weight (float))
var item_weights: Dictionary = {}
# Roll weights for deciding perk focus / attributes (Attribute Index (int) -> Weight (float))
var perk_weights: Dictionary = {}
# The generated equipment state
var generated_item: EquipmentState
# Context quality (Defines.EQUIP_QUALITY)
var quality: float
# Arbitrary flag registry for communication between modifiers
var flags: Dictionary = {}
# Auditing trail for debugging modifier executions
var history: Dictionary = {}
