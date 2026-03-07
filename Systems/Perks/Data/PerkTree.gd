@tool
extends Resource
class_name PerkTree

@export var id: String
@export var display_name: String
@export var tiers: Array[PerkTier] = []

func _init() -> void:
	if tiers: return
	for x in range(Defines.TIERS_PER_PERK_TREE):
		tiers.append(PerkTier.new())

func setup() -> void:
	for x in range(Defines.TIERS_PER_PERK_TREE):
		var tier = tiers[x]
		tier.index = x
		if tier:
			for perk in tier:
				perk.setup(self, tier)
