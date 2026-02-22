extends Resource
class_name PerkTreeLibrary

@export var trees: Array[PerkTree] = []

var _tree_by_id: Dictionary = {}

func _build_index():
	if not _tree_by_id.is_empty():
		return

	for tree in trees:
		if _tree_by_id.has(tree.id):
			push_error("Duplicate perk tree id: %s" % tree.tree_id)
		tree.build()
		_tree_by_id[tree.id] = tree

func get_tree(id: String) -> PerkTree:
	_build_index()
	return _tree_by_id.get(id)

func validate():
	for tree in trees:
		tree.build()
