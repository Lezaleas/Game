extends Node
class_name BattleSimulator

@onready var fighter_handler = %FighterHandler as FighterZZHandler
@onready var clash_handler: ClashHandler = %ClashHandler

func _ready():
	EventBus.subscribe("turn_started", self)

# Processes a single turn of the battle
func on_turn_started():
	Situation.battle.turn += 1
	Log.entry("--- Turn: %d ---" % Situation.battle.turn)
	Log.entry("Positions: %s" % str(Situation.fighters.map(func(f): return f.position_x)))
	
	# apply skills timed by turns
	Situation.skills.resolve(CmdTurnStart.new())

	for reservoir in Situation.reservoirs:
		reservoir.update_multiplier()

	# walk all fighters forward
	for fighter in Situation.fighters:
		fighter_handler.walk_forward(fighter)

	# check for clashes and resolve them
	clash_handler.process_clash()
