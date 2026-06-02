extends MarginContainer

var fighter: FighterState
@export var id: int = 0

# Max value used to normalise the stat bars (fill_ratio 0..1)
const STAT_MAX := 40.0

# Top section — portrait node found by path after ready (instanced sub-scene)
var portrait_sprite: AnimatedSprite2D
@onready var name_label: Label = %Label

# Middle bars (Pwr, Spi, Wis, Agi)
@onready var bar_pwr: Control = %Control
@onready var bar_spi: Control = %Control2
@onready var bar_wis: Control = %Control3
@onready var bar_agi: Control = %Control4

# Bottom skill labels (StatLabel instances)
@onready var skill_label_0: PanelContainer = %SmallPanel
@onready var skill_label_1: PanelContainer = %SmallPanel2
@onready var skill_label_2: PanelContainer = %SmallPanel3
@onready var skill_label_3: PanelContainer = %SmallPanel4

func _ready() -> void:
	add_to_group("refresh")
	# The portrait is inside the FighterPortraitDeluxe instanced sub-scene
	var portrait_panel = get_node_or_null("VBox/PanelContainer2/Content/HBoxContainer/SmallPanel")
	if portrait_panel:
		portrait_sprite = portrait_panel.get_node_or_null("SmallPanel/Content/PanelContainer/AnimatedSprite2D")
	if not portrait_sprite:
		push_warning("FighterPanel %d: portrait_sprite not found" % id)

func refresh_battle_started() -> void:
	fighter = Situation.fighters[id]
	_display()

func _display() -> void:
	if not fighter:
		push_warning("FighterPanel %d: fighter is null" % id)
		return

	# --- Portrait ---
	if fighter.sprite and portrait_sprite:
		portrait_sprite.sprite_frames = fighter.sprite
		var anim_names = fighter.sprite.get_animation_names()
		if not anim_names.is_empty():
			portrait_sprite.animation = anim_names[0]
			portrait_sprite.frame = 0
			portrait_sprite.stop()

	# --- Fighter Name ---
	if name_label:
		name_label.text = "Fighter %d" % fighter.id

	# --- Stat Bars (Pwr, Spi, Wis, Agi = indices 0-3) ---
	var bars = [bar_pwr, bar_spi, bar_wis, bar_agi]
	for i in range(bars.size()):
		var bar = bars[i]
		if bar and fighter.attributes.size() > i:
			bar.fill_ratio = clamp(fighter.attributes[i].current / STAT_MAX, 0.0, 1.0)

	# --- Skill Labels ---
	var visible_skills: Array[Skill] = []
	for skill in fighter.skills:
		if skill and skill.show_to_player:
			visible_skills.append(skill)

	var skill_panels = [skill_label_0, skill_label_1, skill_label_2, skill_label_3]
	for i in range(skill_panels.size()):
		var panel = skill_panels[i]
		if not panel:
			continue
		var lbl: Label = panel.get_node_or_null("Content/MarginContainer/HBoxContainer/Label")
		if not lbl:
			continue
		if i < visible_skills.size():
			lbl.text = visible_skills[i].skill_name
		else:
			lbl.text = ""

func refresh(_delta) -> void:
	if not fighter:
		return

	# Update bars live each frame
	var bars = [bar_pwr, bar_spi, bar_wis, bar_agi]
	for i in range(bars.size()):
		var bar = bars[i]
		if bar and fighter.attributes.size() > i:
			bar.fill_ratio = clamp(fighter.attributes[i].current / STAT_MAX, 0.0, 1.0)
