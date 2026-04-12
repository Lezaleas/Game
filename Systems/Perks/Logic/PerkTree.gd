extends Resource
class_name PerkTree

@export var id: String
@export var index: int
@export var display_name: String
@export var tiers: Array[PerkTier] = []
@export var perk_points: = 0
@export var hero_id: int

func _init() -> void:
	if tiers: return
	for x in range(Defines.TIERS_PER_PERK_TREE):
		tiers.append(PerkTier.new())

func setup(_hero_id:int, tree_index: int) -> void:
	index = tree_index
	hero_id = _hero_id
	for x in range(tiers.size()):
		tiers[x] = tiers[x].duplicate(true)
		var tier = tiers[x]
		tier.index = x
		for y in range (tier.perks.size()):
			tier.perks[y] = tier.perks[y].duplicate(true)
			tier.perks[y].setup(self, tier, hero_id)

func _to_string() -> String:
	return ("PerkTree: " + id)
