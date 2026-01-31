extends Control

@onready var skill_count_input = $VBoxContainer/HBoxContainer/LineEdit
@onready var output_label = $VBoxContainer/OutputLabel

func pick_random_skills() -> void:
	var amount = int(skill_count_input.text)
	if amount <= 0:
		amount = 25 # Default or random testing value
	var all_skills = [] as Array[Skill]
	var lib = Situation.skill_library
	if lib:
		all_skills.append_array(lib.regular_skills)
		all_skills.append_array(lib.mana_skills)
		all_skills.append_array(lib.ulti_skills)
	if all_skills.is_empty():
		output_label.text = "Error: Skill Library is empty!"
		return
	var selected_skills = [] as Array[Skill]
	var pool = all_skills.duplicate()
	pool.shuffle()
	for i in range(min(amount, pool.size())):
		selected_skills.append(pool[i])
	output_label.text = "Selected " + str(selected_skills.size()) + " random skills."
	EventBus.emit("debug_skills_selected", selected_skills)
	print("Debug Skill Selector: Picked ", selected_skills.size(), " skills.")

func _on_random_button_pressed() -> void:
	pick_random_skills()
