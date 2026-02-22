extends Node
class_name PerkController

var unlocked_perks: Dictionary = {} # perk_id -> rank
var available_points: int = 0
var tree: PerkTree

func setup(perk_tree: PerkTree):
	tree = perk_tree
	tree.build()

func can_unlock(perk_id: String) -> bool:
	if not tree.perk_by_id.has(perk_id):
		push_warning("PerkController.can_unlock: unknown perk_id '%s'" % perk_id)
		return false

	var perk := tree.perk_by_id[perk_id]
	if available_points < perk.cost:
		return false

	# AND check: every explicit prerequisite must be unlocked
	for prereq_id in tree.dependency_graph.keys():
		if perk_id in tree.dependency_graph[prereq_id]:
			if not unlocked_perks.has(prereq_id):
				return false

	# OR check: if this perk has tag requirements, at least one candidate must be unlocked
	var tag_prereqs: Array = tree.tag_dependency_graph.get(perk_id, [])
	if not tag_prereqs.is_empty():
		var any_satisfied := false
		for prereq_id in tag_prereqs:
			if unlocked_perks.has(prereq_id):
				any_satisfied = true
				break
		if not any_satisfied:
			return false

	return true

func unlock(perk_id: String, character) -> bool:
	if not can_unlock(perk_id):
		return false

	var perk := tree.perk_by_id[perk_id]
	unlocked_perks[perk_id] = 1
	available_points -= perk.cost

	for effect in perk.effects:
		effect.apply(character)

	return true
