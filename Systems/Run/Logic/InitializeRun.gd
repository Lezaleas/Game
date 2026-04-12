extends Node

func _ready() -> void:

	if RunManager.loaded_run:
		var loaded_run = RunManager.loaded_run
		RunManager.equipment.clear()
		RunManager.heroes.clear()
		RunManager.shrines.clear()
		RunManager.run_seed = loaded_run.run_seed
		RunManager.run_rng.seed = RunManager.run_seed
		RunManager.heroes = loaded_run.heroes
		RunManager.shrines = loaded_run.shrines
		RunManager.equipment = loaded_run.equipment
		RunManager.loaded_run = null
		EventBus.emit("run_loaded")
		return

	randomize()
	RunManager.run_seed = randi()
	RunManager.run_rng.seed = RunManager.run_seed
	RunManager.shrines = Defines.perktrees.trees.duplicate(true)
	# intialize a team of 4 blank heroes
	RunManager.heroes = []
	for x in range(Defines.TEAM_SIZE):
		var hero = HeroState.new()
		hero.id = x
		hero.setup()
		RunManager.heroes.append(hero)
	EventBus.emit("run_started")
