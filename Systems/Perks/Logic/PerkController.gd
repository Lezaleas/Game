extends Node
class_name PerkController

func can_unlock(perk: Perk, perk_tree: PerkTreeState, hero: HeroState) -> bool:
	if hero.perk_points < perk.cost:
		return false
	if perk_tree.unlocked_tier_level < perk.tier_index:
		return false
	return true

func unlock(perk: Perk, perk_tree: PerkTreeState, hero: HeroState) -> bool:
	if not can_unlock(perk, perk_tree, hero):
		return false

	perk_tree.unlocked_perks.append(perk)
	hero.perk_points -= perk.cost

	for effect in perk.effects:
		effect.apply(hero)

	return true
