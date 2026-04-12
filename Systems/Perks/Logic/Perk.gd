extends Resource
class_name Perk

@export var id: String
@export var display_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var cost: int = 1
@export var effects: Array[PerkEffect] = []
@export var perk_points: int = 0
@export var unlocked: = false
@export var favorited: = false
@export var tree_index: int
@export var tier_index: int
@export var hero_id: int

func setup(perk_tree: PerkTree, perk_tier: PerkTier, _hero_id) -> void:
	tier_index = perk_tier.index
	tree_index = perk_tree.index
	hero_id = _hero_id
	
	if effects:
		var main_effect: = effects[0]
		if main_effect is SkillPerk:	# make description match the skill if applicable
			description = main_effect.skill.description
			
func unlock_or_remove(true_to_unlock:bool) -> void:
	var hero = RunManager.heroes[hero_id]
	if true_to_unlock:
		for effect in effects:
			effect.unlock(hero)
	else:
		for effect in effects:
			effect.remove(hero)

func _to_string() -> String:
	return ("Perk: " + id)
