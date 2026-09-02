extends Node
class_name BattleSimulator

@onready var fighter_handler = %FighterHandler as FighterLogic
@onready var clash_handler: ClashHandler = %ClashHandler
@onready var win_handler: WinHandler = %WinHandler

func on_battle_started():
	if Situation.battle.simulation:
		run_arena()
	else:
		EventBus.subscribe("turn_started", self)

func run_arena():
	while not Situation.battle.finished:
		on_turn_started()

# Processes a single turn of the battle
func on_turn_started():
	Situation.battle.turn += 1

	Log.entry("\n")
	Log.entry("--- Turn: %d ---" % Situation.battle.turn)
	Log.entry("Positions: %s" % str(Situation.fighters.map(func(f): return f.position_x)))

	# update entities
	for attribute in Situation.attributes:
		attribute.update()

	for reservoir in Situation.reservoirs:
		reservoir.update_multiplier()

	# apply skills timed by turns
	Situation.skills.resolve(CmdTurnStart.new())

	# tick buffs
	for fighter in Situation.fighters:
		fighter.buffs.tick_all()

	# walk all fighters forward and process their turn
	for fighter in Situation.fighters:
		fighter_handler.walk_forward(fighter)
		fighter_handler.process_turn(fighter)

	# check for clashes and resolve them
	clash_handler.process_clash()

	# check if the battle has ended
	win_handler.check_win_condition()
