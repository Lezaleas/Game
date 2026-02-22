extends Node

func _ready() -> void:
	RunManager.run = RunState.new()
	
	# intialize a team of 4 blank heroes
	RunManager.heroes = []
	for x in range(Defines.TEAM_SIZE):
		var hero = HeroState.new()
		hero.id = x
		RunManager.heroes.append(hero)
		
	# load default skills
	RunManager.skills = Defines.skills.starting_skills.duplicate(true)
		
	EventBus.emit("run_started")
