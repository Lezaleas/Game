extends PanelContainer
class_name SkillPoolsPanel

@onready var category_list = %CategoryList
@onready var close_button = %CloseButton

func _ready() -> void:
	close_button.pressed.connect(hide)
	hide()

func display() -> void:
	show()
	refresh()

func refresh() -> void:
	for child in category_list.get_children():
		child.queue_free()
	
	for tag_id in RunManager.skill_pools:
		var pool = RunManager.skill_pools[tag_id] as Array
		
		var cat_box = VBoxContainer.new()
		category_list.add_child(cat_box)
		
		var title = Label.new()
		title.text = "--- " + Defines.PROG_TAG.keys()[tag_id] + " ---"
		title.add_theme_color_override("font_color", Color(1.0, 0.8, 0.2))
		cat_box.add_child(title)
		
		var skills_box = HFlowContainer.new()
		cat_box.add_child(skills_box)
		
		if pool.is_empty():
			var empty_lbl = Label.new()
			empty_lbl.text = "No skills"
			empty_lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			skills_box.add_child(empty_lbl)
		else:
			for skill in pool:
				if skill == null: continue
				var s_lbl = Label.new()
				s_lbl.text = "[" + skill.skill_name + "]"
				s_lbl.tooltip_text = skill.description
				s_lbl.mouse_filter = Control.MOUSE_FILTER_PASS
				skills_box.add_child(s_lbl)
