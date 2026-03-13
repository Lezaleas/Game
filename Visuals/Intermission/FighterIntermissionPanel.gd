extends Panel

@onready var skill_inventory: SkillGrid = %SkillInventory
@export var fighter: HeroState

func _ready() -> void:
	update()
	return

func update() -> void:
	if fighter:
		skill_inventory.populate(fighter.skills, 4)
