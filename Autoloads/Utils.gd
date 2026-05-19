extends CanvasLayer

var debug_label: Label

func _ready() -> void:
	debug_label = Label.new()
	debug_label.visible = true
	debug_label.position = Vector2(10, 10) # top-left corner
	add_child(debug_label)

## debug function
func show_debug(text: String) -> void:
	debug_label.text = text
	debug_label.visible = true

func hide_debug() -> void:
	debug_label.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
	
	if event.is_action_pressed("q"):
		debug_label.text = ""
		debug_label.text += "\n" + str(RunManager.heroes[1].skills)
		
## Returns a number between 1 and max_value inclusive.
## Pass the RNG instance you want to use.
func roll_dice(max_value: int, rng: RandomNumberGenerator) -> int:
	return rng.randi_range(1, max_value)

## Returns true with the given percent chance.
## Example: 20.0 = 20% chance.
func chance(percent: float, rng: RandomNumberGenerator) -> bool:
	return rng.randf() < percent / 100.0

## receives a herostate and a fighterstate and writes the hero properties on the fighter
func HeroToFighter(hero:HeroState, fighter:FighterState) -> FighterState:

	var equipment_attributes: = hero.get_equip_attributes()
	for x in range(Defines.ATTRIBUTE.size()):	#set attributes
		fighter.attributes[x].base = hero.attributes_base[x]
		fighter.attributes[x].mult = hero.attributes_mult[x]
		fighter.attributes[x].base += equipment_attributes[x]

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
