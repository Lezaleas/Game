extends Node

@export var debug_data: InitDebugData

func _ready() -> void:
	match RunManager.load_mode:
		RunManager.RunLoadMode.NEW_RUN: _start_new_run()
		RunManager.RunLoadMode.RESUME_RUN: EventBus.emit("run_resumed")
		RunManager.RunLoadMode.LOAD_SAVE: _load_save()
			
func _load_save() -> void:
	if not RunManager.loaded_run:
		push_error("Tried to load save but loaded_run is null")
		return
	var loaded_run = RunManager.loaded_run
	RunManager.equipment.clear()
	RunManager.heroes.clear()
	RunManager.shrines.clear()
	RunManager.skill_pool.clear()
	RunManager.run_rng = RandomNumberGenerator.new()
	RunManager.run_rng.seed = loaded_run.run_seed
	RunManager.run_rng.state = loaded_run.rng_state
	RunManager.heroes = loaded_run.heroes
	RunManager.shrines = loaded_run.shrines
	RunManager.equipment = loaded_run.equipment
	RunManager.buildings = loaded_run.buildings
	RunManager.villagers = loaded_run.villagers
	RunManager.reserve_villagers = loaded_run.reserve_villagers
	RunManager.skill_pools = loaded_run.skill_pools
	RunManager.levels = loaded_run.levels
	RunManager.critters = loaded_run.critters
	RunManager.arena_record = loaded_run.arena_record
	RunManager.skill_pool = loaded_run.skill_pool
	RunManager.loaded_run = null
	RunManager.load_mode = RunManager.RunLoadMode.RESUME_RUN
	EventBus.emit("run_loaded")

func _start_new_run() -> void:
	randomize()
	RunManager.run_seed = randi()
	RunManager.run_rng.seed = RunManager.run_seed
	RunManager.skill_pool = SkillPool.new()
	RunManager.skill_pool.setup(debug_data.skill_pool)
	RunManager.shrines = Defines.perktrees.trees.duplicate(true)
	RunManager.heroes = []
	for x in range(Defines.TEAM_SIZE):
		var hero = HeroState.new()
		hero.id = x
		hero.setup()
		RunManager.heroes.append(hero)
	RunManager.load_mode = RunManager.RunLoadMode.RESUME_RUN
	EventBus.emit("run_started")
