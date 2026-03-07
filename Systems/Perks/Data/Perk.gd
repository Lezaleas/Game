extends Resource
class_name Perk

@export var id: String
@export var display_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var cost: int = 1
@export var effects: Array[PerkEffect] = []

var perk_tree: PerkTree
var perk_tier: PerkTier

func setup(_perk_tree: PerkTree, _perk_tier: PerkTier) -> void:
	perk_tier = _perk_tier
	perk_tree = _perk_tree
