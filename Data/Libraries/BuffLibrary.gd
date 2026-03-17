extends Resource
class_name BuffLibrary

@export var buffs: Array[Buff] = []
var _buff_dict: Dictionary = {}

func get_buff(id: Defines.BUFF) -> Buff:
	if _buff_dict.is_empty():
		_populate_dict()
	return _buff_dict.get(id)

func _populate_dict() -> void:
	for buff in buffs:
		_buff_dict[buff.id] = buff

func _to_string() -> String:
	return "Buff Library: " + str(buffs)
