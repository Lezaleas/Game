extends Resource
class_name PerkTree

@export var id: String
@export var display_name: String

# X exportable tiers, fully editor-defined
@export var tiers: Array[PerkTier] = []

# Built data (typed)
var perk_by_id: Dictionary[String, Perk] = {}
var perk_tier: Dictionary[String, int] = {} # perk_id -> tier_index
var dependency_graph: Dictionary[String, Array] = {} # prereq_id -> [dependent perk_ids]  (AND: ALL must be unlocked)
var tag_dependency_graph: Dictionary[String, Array] = {} # perk_id -> [candidate prereq_ids]  (OR: ANY one suffices)

func build() -> void:
	_index_perks()
	_build_dependency_graph()
	_build_tag_dependency_graph()

func _index_perks() -> void:
	perk_by_id.clear()
	perk_tier.clear()

	for tier: PerkTier in tiers:
		for perk: Perk in tier.perks:
			perk_by_id[perk.id] = perk
			perk_tier[perk.id] = tier.tier_index

func _build_dependency_graph() -> void:
	dependency_graph.clear()

	for perk_id: String in perk_by_id.keys():
		dependency_graph[perk_id] = []

	for perk: Perk in perk_by_id.values():
		var perk_id: String = perk.id
		var my_tier: int = perk_tier[perk_id]

		# Explicit perk requirements (AND: every listed prereq must be unlocked)
		for req_id: String in perk.requires_perks:
			if perk_by_id.has(req_id) and perk_tier[req_id] < my_tier:
				dependency_graph[req_id].append(perk_id)
			else:
				push_warning("PerkTree '%s': perk '%s' requires_perk '%s' is missing or not in a lower tier." % [id, perk_id, req_id])

func _build_tag_dependency_graph() -> void:
	tag_dependency_graph.clear()

	for perk_id: String in perk_by_id.keys():
		tag_dependency_graph[perk_id] = []

	for perk: Perk in perk_by_id.values():
		var perk_id: String = perk.id
		var my_tier: int = perk_tier[perk_id]

		if perk.requires_tags.is_empty():
			continue

		# Tag-based requirements (OR: any one matching candidate from a lower tier suffices)
		for other_id: String in perk_by_id.keys():
			if other_id == perk_id:
				continue
			if perk_tier[other_id] >= my_tier:
				continue
			if _matches_tag_requirement(perk, perk_by_id[other_id]):
				tag_dependency_graph[perk_id].append(other_id)

func _matches_tag_requirement(perk: Perk, candidate: Perk) -> bool:
	if perk.requires_tags.is_empty():
		return false

	for tag: String in perk.requires_tags:
		if tag in candidate.tags:
			return true

	return false
