extends Resource
class_name EquipmentState

@export var num_id: int = 0
@export var display_name: String = "Shortsword"
@export var icon: Texture2D = load("res://Assets/Sprites/Common/ElementalIcons/Grey.tres")
@export var attributes: Array[int] = [0,0,0,0]
@export var perk_points: Array[int] = [0,0,0,0]
@export var weight: int = 10
@export var type: Defines.EQUIP_TYPE
