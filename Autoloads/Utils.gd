extends CanvasLayer

## debug function
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
	
	if event.is_action_pressed("q"):
		var item = EquipmentGenerator.generate_item(Defines.EQUIP_QUALITY.Common, Defines.EQUIP_TYPE.Sword)
		RunManager.equipment.append(item)


## receives a herostate and a fighterstate and writes the hero properties on the fighter
func HeroToFighter(hero:HeroState, fighter:FighterState) -> FighterState:

	var equipment_attributes: = hero.get_equip_attributes()
	for x in range(Defines.ATTRIBUTE.size()):	#set attributes
		fighter.attributes[x].base = hero.attributes_base[x]
		fighter.attributes[x].base += equipment_attributes[x]
		fighter.attributes[x].mult = hero.attributes_mult[x]

	fighter.skills = hero.skills.duplicate(true) + hero.passives.duplicate(true)
	fighter.sprite = hero.sprite
	return fighter
	
## receives a enemydata and a fighterstate and writes the hero properties on the fighter
func EnemyToFighter(enemy:EnemyData, fighter:FighterState) -> FighterState:
	
	for x in range(Defines.ATTRIBUTE.size())	:#set attributes
		fighter.attributes[x].base = enemy.attributes_base[x]
		fighter.attributes[x].mult = enemy.attributes_mult[x]

	fighter.skills = (enemy.skills.duplicate(true) + enemy.passives.duplicate(true)).filter(
		func(s): return s != null
	)

	fighter.sprite = enemy.sprite
	return fighter
