extends Resource
class_name FighterState

# Core Stats from GDD
@export var power: int = 10
@export var magic: int = 10
@export var wisdom: int = 10
@export var speed: int = 10

# Resources from GDD
@export var mana: int = 0
@export var stamina: int = 100

# Current position on the X-axis
@export var position_x: float = 0.0
@export var position_y: float = 0.0
@export var id: int = 0
@export var is_clashing: bool = false
