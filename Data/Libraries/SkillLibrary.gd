extends Resource
class_name SkillLibrary

@export var regular_skills: Array[Skill] = []
@export var mana_skills: Array[Skill] = []
@export var ulti_skills: Array[Skill] = []
@export var starting_skills: Array[Skill] = []

func _to_string() -> String:
	return ("Skill Library: " + str(regular_skills))
