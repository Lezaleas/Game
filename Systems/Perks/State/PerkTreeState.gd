extends Resource
class_name PerkTreeState

var tree: PerkTree
var unlocked_perks: Array[Perk] = []
var owner: HeroState
var unlocked_tier_level: int = 3
