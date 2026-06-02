extends PanelContainer

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var stats_grid: GridContainer = $VBoxContainer/StatsGrid
@onready var skills_list: VBoxContainer = $VBoxContainer/SkillsList

func display(enemy_data: EnemyData) -> void:
	if not enemy_data:
		return
		
	name_label.text = enemy_data.id
	
	# Clear stats
	for child in stats_grid.get_children():
		child.queue_free()
		
	# Populate stats
	var attr_keys = Defines.ATTRIBUTE.keys()
	for i in range(min(enemy_data.attributes_base.size(), attr_keys.size())):
		var lbl_name = Label.new()
		lbl_name.text = str(attr_keys[i]) + ":"
		stats_grid.add_child(lbl_name)
		
		var lbl_val = Label.new()
		lbl_val.text = str(enemy_data.attributes_base[i])
		stats_grid.add_child(lbl_val)
		
	# Clear skills
	for child in skills_list.get_children():
		child.queue_free()
		
	# Populate skills
	for skill in enemy_data.skills:
		if skill:
			var skill_lbl = Label.new()
			skill_lbl.text = "- " + skill.skill_name
			skill_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			var desc_lbl = Label.new()
			desc_lbl.text = skill.description
			desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			desc_lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
			
			skills_list.add_child(skill_lbl)
			skills_list.add_child(desc_lbl)
