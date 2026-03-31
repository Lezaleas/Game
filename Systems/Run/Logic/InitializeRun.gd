extends Node

func _ready() -> void:
	if RunManager.run != null:
		return

	randomize()
	RunManager.run_seed = randi()
	RunManager.run_rng.seed = RunManager.run_seed
	
	RunManager.run = RunState.new()
	RunManager.heroes = RunManager.run.heroes
	RunManager.shrines = Defines.perktrees.trees.duplicate(true)
	
	# intialize a team of 4 blank heroes
	RunManager.heroes = []
	for x in range(Defines.TEAM_SIZE):
		var hero = HeroState.new()
		hero.id = x
		hero.setup()
		RunManager.run.heroes.append(hero)
		RunManager.heroes.append(hero)
		
	EventBus.emit("run_started")
