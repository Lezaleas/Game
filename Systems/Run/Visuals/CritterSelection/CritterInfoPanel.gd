extends PanelContainer
class_name CritterInfoPanel

@onready var name_label: Label = %NameLabel
@onready var attributes_label: Label = %AttributesLabel
@onready var skills_label: Label = %SkillsLabel

func display_critter(critter: Critter) -> void:
	if not critter:
		return
	name_label.text = "Critter: " + str(critter.id)
	attributes_label.text = "Attributes: " + str(critter.attributes)
	
	var skills_text = "Skills:\n"
	if critter.perk_tree:
		for tier in critter.perk_tree.tiers:
			for perk in tier.perks:
				skills_text += "- " + perk.display_name + "\n"
	skills_label.text = skills_text

func display_fighter(fighter: HeroState) -> void:
	if not fighter:
		return
	name_label.text = "Fighter: " + str(fighter.id)
	attributes_label.text = "Base Attributes: " + str(fighter.attributes_base)
	
	var skills_text = "Skills:\n"
	for skill in fighter.skills:
		skills_text += "- " + skill.skill_name + "\n"
	skills_label.text = skills_text

func clear() -> void:
	name_label.text = "Hover an item to see details"
	attributes_label.text = ""
	skills_label.text = ""
