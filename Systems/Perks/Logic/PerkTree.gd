extends Resource
class_name PerkTree

@export var id: String
@export var index: int
@export var display_name: String
@export var tiers: Array[PerkTier] = []
@export var perk_points: = 0
@export var hero_id: int

func _init() -> void:
	"""if tiers: return
	for x in range(Defines.TIERS_PER_PERK_TREE):
		tiers.append(PerkTier.new())"""

func setup(_hero_id:int, tree_index:int) -> void:
	index = tree_index
	hero_id = _hero_id
	for x in range(tiers.size()):
		tiers[x] = tiers[x].duplicate(true)
		var tier = tiers[x]
		tier.index = x
		for y in range (tier.perks.size()):
			tier.perks[y] = tier.perks[y].duplicate(true)
			tier.perks[y].setup(self, tier, hero_id)
			
func convert_to_equipment_skill(skill: Skill) -> void:
	for tier in tiers:
		for i in range(tier.perks.size()):
			var unlocked := tier.perks[i].unlocked
			tier.perks[i] = SkillPerk.skill_to_perk(skill)
			tier.perks[i].unlocked = unlocked

## returns the perk that is unlocked in x, y coordinates. returns -1, -1 if no perk is found	
func get_unlock_position() -> Vector2i:
	for x in range(tiers.size()):
		for y in range(tiers[x].perks.size()):
			if tiers[x].perks[y].unlocked:
				return Vector2i(x, y)
	return Vector2i(-1, -1)
	
func set_unlock_position(pos: Vector2i) -> void:
	if pos == Vector2i(-1, -1): return
	if pos.x < 0 or pos.x >= tiers.size(): return
	if pos.y < 0 or pos.y >= tiers[pos.x].perks.size(): return
	tiers[pos.x].perks[pos.y].unlocked = true

func _to_string() -> String:
	return ("PerkTree: " + id)
