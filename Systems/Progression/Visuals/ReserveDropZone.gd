extends Control
# ReserveDropZone.gd
# Handles dropping villagers back into the reserve.

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Villager

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var villager = data as Villager
	ProgressionManager.move_to_reserve(villager)
	
	# Signal refresh
	EventBus.emit("progression_updated", {})
