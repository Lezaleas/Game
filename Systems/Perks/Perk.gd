extends Resource
class_name Perk

@export var id: String
@export var display_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var cost: int = 1
@export var effects: Array[PerkEffect] = []

@export var tags: Array[String] = []
@export var requires_tags: Array[String] = []
@export var requires_perks: Array[String] = []
