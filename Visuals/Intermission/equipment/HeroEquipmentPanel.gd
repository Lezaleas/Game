extends Panel
class_name HeroEquipmentPanel

@onready var equipment_grid: EquipmentGrid = %EquipmentGrid
@export var hero: HeroState

func _ready() -> void:
	update()

func update() -> void:
	if hero:
		%HeroName.text = "Hero " + str(hero.id)
		equipment_grid.populate(hero.equipment_slots, 4)
	else:
		%HeroName.text = "None"
