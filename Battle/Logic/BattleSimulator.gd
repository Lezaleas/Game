extends Node
class_name BattleSimulator

@onready var fighter_handler = %FighterHandler as FighterLogic
@onready var clash_handler: ClashHandler = %ClashHandler
@onready var win_handler: WinHandler = %WinHandler

func _ready():
	EventBus.subscribe("turn_started", self)

# Processes a single turn of the battle
func on_turn_started():
	Situation.battle.turn += 1
	Log.entry("\n")
	Log.entry("--- Turn: %d ---" % Situation.battle.turn)
	Log.entry("Positions: %s" % str(Situation.fighters.map(func(f): return f.position_x)))
	
	# apply skills timed by turns
	Situation.skills.resolve(CmdTurnStart.new())

	# update entities
	for attribute in Situation.attributes:
		attribute.update()
	for reservoir in Situation.reservoirs:
		reservoir.update_multiplier()

	# walk all fighters forward and process their turn
	for fighter in Situation.fighters:
		fighter_handler.walk_forward(fighter)
		fighter_handler.process_turn(fighter)

	# check for clashes and resolve them
	clash_handler.process_clash()
	
	# check if one side won the battle and execute the battle won signal
	win_handler.check_win_condition()
