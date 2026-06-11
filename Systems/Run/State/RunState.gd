extends Resource
class_name RunState

@export var heroes: Array[HeroState]
@export var shrines: Array[PerkTree]
@export var equipment: Array[EquipmentState]
@export var buildings: Array[Building]
@export var villagers: Array[Villager]
@export var reserve_villagers: Array[Villager]
@export var skill_pools: Dictionary
@export var run_seed: int
@export var rng_state: int
@export var level: int = 1
@export var levels: Array[LevelData]
@export var critters: Array[Critter]
@export var arena_record: int
@export var skill_pool: SkillPool

static func save_run() -> RunState:
	var state = RunState.new()
	state.run_seed = RunManager.run_seed
	state.rng_state = RunManager.run_rng.state
	state.heroes = RunManager.heroes.duplicate(true)
	state.shrines = RunManager.shrines.duplicate(true)
	state.equipment = RunManager.equipment.duplicate(true)
	state.buildings = RunManager.buildings.duplicate(true)
	state.villagers = RunManager.villagers.duplicate(true)
	state.reserve_villagers = RunManager.reserve_villagers.duplicate(true)
	state.skill_pools = RunManager.skill_pools.duplicate(true)
	state.levels = RunManager.levels.duplicate(true)
	state.critters = RunManager.critters.duplicate(true)
	state.arena_record = RunManager.arena_record
	state.skill_pool = RunManager.skill_pool.duplicate(true)
	
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
