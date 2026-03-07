extends Node

## receives a herostate and a fighterstate and writes the hero properties on the fighter
func HeroToFighter(hero:HeroState, fighter:FighterState) -> FighterState:
	#set attributes
	for x in range(Defines.ATTRIBUTE.size()):
		fighter.attributes[x].base = hero.attributes_base[x]
		fighter.attributes[x].mult = hero.attributes_mult[x]
		
	# set skills
	fighter.skills = hero.skills.duplicate(true) + hero.passives.duplicate(true)
		
	return fighter
