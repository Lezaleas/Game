class_name EquipmentGrid
extends Control

@export var columns: int = 5
@onready var grid: GridContainer = %GridContainer
@onready var slot_scene := preload("res://Systems/Equipment/Visuals/EquipmentSlot.tscn") as PackedScene
var slots: Array[EquipmentSlot] = []

func _ready() -> void:
	if grid:
		grid.columns = columns

func populate(items: Array[EquipmentState], fixed_size: int = -1) -> void:
	_clear()
	var count = items.size()
	if fixed_size > 0:
		count = fixed_size
	
	for i in range(count):
		var slot: EquipmentSlot = slot_scene.instantiate()
		grid.add_child(slot)
		slots.append(slot)
		
		slot.index = i
		slot.source_array = items
		
		var item: EquipmentState = null
		if i < items.size():
			item = items[i]
		
		# If it's a "hero slot" grid, assign type restriction
		if fixed_size == 4:
			slot.equip_type_restriction = i # 0: Weapon, 1: Helmet, 2: Armor, 3: Accessory

		slot.set_equipment(item)

func _clear() -> void:
	for slot in slots:
		if is_instance_valid(slot):
			slot.queue_free()
	slots.clear()
