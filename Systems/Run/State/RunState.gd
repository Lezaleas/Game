extends Resource
class_name RunState

@export var heroes: Array[HeroState]
@export var shrines: Array[PerkTree]
@export var equipment: Array[EquipmentState]
@export var run_seed: int
@export var level: int = 1

static func save_run() -> RunState:
	var state = RunState.new()
	state.run_seed = RunManager.run_seed
	state.heroes = RunManager.heroes.duplicate(true)
	state.shrines = RunManager.shrines.duplicate(true)
	state.equipment = RunManager.equipment.duplicate(true)
	
	var err = ResourceSaver.save(state, "user://run.tres")
	if err != OK:
		push_warning("Failed to save run: %s" % err)
		print("Error Code: ", err)
	return state

static func load_run() -> RunState:
	if not FileAccess.file_exists("user://run.tres"):
		return null
	var state = ResourceLoader.load("user://run.tres")
	return state as RunState
