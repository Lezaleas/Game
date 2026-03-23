extends CanvasLayer

## debug function
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
	
	if event.is_action_pressed("q"):
		# clear previous debug
		for child in get_children():
			child.queue_free()
		
		var label := Label.new()
		label.position = Vector2(10, 10)
		label.text = "debug:"
		
		for hero in RunManager.heroes:
			for equipment in hero.equipment_slots:
				if equipment:
					label.text += "\n" + equipment.display_name
		
		add_child(label)



## receives a herostate and a fighterstate and writes the hero properties on the fighter
func HeroToFighter(hero:HeroState, fighter:FighterState) -> FighterState:
	#set attributes
	var equipment_attributes: = hero.get_equip_attributes()
	for x in range(Defines.ATTRIBUTE.size()):
		fighter.attributes[x].base = hero.attributes_base[x]
		fighter.attributes[x].base += equipment_attributes[x]
		fighter.attributes[x].mult = hero.attributes_mult[x]
		
		
	# set skills
	fighter.skills = hero.skills.duplicate(true) + hero.passives.duplicate(true)
	
	# set spriteframes
	print(hero.sprite)
	fighter.sprite = hero.sprite
		
	return fighter
