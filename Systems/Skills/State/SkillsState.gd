extends Resource
class_name SkillsState

## Dictionary of active skills by category, keys come from Defines.CMD_EVENT_TYPE
var skills_by_category: Dictionary[String, Array] = {}
var self_skills_by_category: Dictionary[String, Array] = {}

func _init():
	# Ensure every category from Defines has an empty array
	for category in Defines.CMD_EVENT_TYPE:
		skills_by_category[category] = []
		self_skills_by_category[category] = []

## adds a skill to the registry and returns it
func add_skill(fighter:FighterState, skill:Skill, skip_sort:bool=false) -> Skill:
	skill = skill.duplicate(true)
	skill.owner = fighter

	for key in Defines.CMD_EVENT_TYPE:
		if skill.has_method(key):
			skills_by_category[key].append(skill)
			if not skip_sort:
				skills_by_category[key].sort_custom(_sort_by_priority)
		if skill.has_method("Self" + key):
			self_skills_by_category[key].append(skill)
			if not skip_sort:
				self_skills_by_category[key].sort_custom(_sort_by_priority)
	return skill

func _sort_by_priority(a: Skill, b: Skill) -> bool:
	return a.order < b.order

## receives an event and resolves any skills subscribed to it, then returns the event
func resolve(command: CmdEvent) -> CmdEvent:
	# get the class name of the command, and translate it to the method we want to call
	var key: String =  str(command.get_script().get_global_name())
	key = key.substr(3, key.length() - 3)
	
	# get the list of skills subscribed to the key
	var relevant_skills:Array = skills_by_category[key]
	var relevant_self_skills:Array = self_skills_by_category[key]
	
	for skill in relevant_skills:
		command = skill.call(key, command)
	for skill in relevant_self_skills:
		if command.fighter_trigger == skill.owner:
			command = skill.call("Self" + key, command)
	return command

func _to_string() -> String:
	return ("Skills: " + str(skills_by_category))
