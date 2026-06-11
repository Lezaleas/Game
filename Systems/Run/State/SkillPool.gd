class_name SkillPool
extends Resource

@export var _skills:Array[Skill] = []
@export var _weights:Dictionary = {}

func setup(skills:Array[Skill]) -> void:
	_skills = skills.duplicate()
	for skill in _skills:
		_weights[skill] = 1.0

func draw_skill() -> Skill:
	if _skills.is_empty():
		return null
	var total_weight:float = 0.0
	for skill in _skills:
		total_weight += get_weight(skill)
	if total_weight <= 0.0:
		return null
	var roll := RunManager.run_rng.randf_range(0.0, total_weight)
	for skill in _skills:
		roll -= get_weight(skill)
		if roll <= 0.0:
			return skill
	return _skills.back()

func add_skill(skill:Skill, weight:float = 1.0) -> void:
	if skill == null:
		return
	if skill in _skills:
		return
	_skills.append(skill)
	_weights[skill] = max(weight, 0.0)

func remove_skill(skill:Skill) -> void:
	_skills.erase(skill)
	_weights.erase(skill)

func has_skill(skill:Skill) -> bool:
	return skill in _skills

func get_weight(skill:Skill) -> float:
	return max(_weights.get(skill, 0.0), 0.0)

func set_weight(skill:Skill, weight:float) -> void:
	if not has_skill(skill):
		return
	_weights[skill] = max(weight, 0.0)

func add_weight(skill:Skill, amount:float) -> void:
	if not has_skill(skill):
		return
	_weights[skill] = max(get_weight(skill) + amount, 0.0)

func multiply_weight(skill:Skill, multiplier:float) -> void:
	if not has_skill(skill):
		return
	_weights[skill] = max(get_weight(skill) * multiplier, 0.0)

func clear() -> void:
	_skills.clear()
	_weights.clear()

func size() -> int:
	return _skills.size()

func is_empty() -> bool:
	return _skills.is_empty()

func get_skills() -> Array[Skill]:
	return _skills.duplicate()
