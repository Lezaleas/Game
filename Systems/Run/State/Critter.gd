extends Resource
class_name Critter

@export var id: String
@export var perk_tree: PerkTree
@export var attributes: = [0,0,0,0, 1,1,1,1,1,1,1,]
@export var sprite: SpriteFrames

func equip_to_hero(hero:HeroState) -> void:
	hero.critter = self
	hero.attributes_base = attributes
	hero.sprite = sprite
	for other_hero in RunManager.heroes:
		other_hero.swap_perk_tree(perk_tree, hero.id)

## Receives an enemydata resource and takes it's values
func ConvertFromEnemy(enemy:EnemyData):
	sprite = enemy.sprite
	id = enemy.id
	for x in range(4):
		attributes[x] = enemy.attributes_base[x] / 2
	perk_tree = PerkTree.new()
	var skills: Array[Skill] = enemy.skills.duplicate(true)
	var perk_tiers = perk_tree.tiers
	perk_tree.id = enemy.id
	perk_tree.display_name = enemy.id
	for skill in skills:
		if not skill: continue
		var tier = PerkTier.new()
		var perk = Perk.new()
		var skill_perk = SkillPerk.new()
		skill_perk.skill = skill
		perk.effects.append(skill_perk)
		perk.id = skill.skill_name
		perk.display_name = skill.skill_name
		tier.perks.append(perk)
		perk_tiers.append(tier)

func _to_string() -> String:
	return "critter: " + id
