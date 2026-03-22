extends Node

func _ready() -> void:
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
		print(RunManager.heroes)
		
	# load default skills
	RunManager.skills = Defines.skills.starting_skills.duplicate(true)
		
	EventBus.emit("run_started")
