extends Node
class_name EquipmentSelection

@onready var hero_panel_0: HeroEquipmentPanel = %HeroPanel0
@onready var hero_panel_1: HeroEquipmentPanel = %HeroPanel1
@onready var hero_panel_2: HeroEquipmentPanel = %HeroPanel2
@onready var hero_panel_3: HeroEquipmentPanel = %HeroPanel3
@onready var hero_panels: Array[HeroEquipmentPanel]
@onready var inventory_grid: EquipmentGrid = %InventoryGrid
@onready var discard_button: Button = %DiscardButton
@onready var swap_handler: EquipmentSwapHandler = $EquipmentSwapHandler

func _ready() -> void:
	if discard_button:
		discard_button.pressed.connect(_on_discard_pressed)
	hero_panels = [hero_panel_0, hero_panel_1, hero_panel_2, hero_panel_3]
	refresh()

func refresh() -> void:
	var equipped_items := get_equipped_items()
	
	# Update Hero Panels
	for i in range(min(RunManager.heroes.size(), 4)):
		hero_panels[i].hero = RunManager.heroes[i]
		hero_panels[i].update()
	
	# Filter inventory to skip equipped items
	var available_equipment = RunManager.equipment.filter(func(e): return e not in equipped_items)
	inventory_grid.populate(available_equipment, 16)

func get_equipped_items() -> Array[EquipmentState]:
	var result: Array[EquipmentState] = []
	for hero in RunManager.heroes:
		for item in hero.equipment_slots:
			if item:
				result.append(item)
	return result

func _on_discard_pressed() -> void:
	if not swap_handler: return
	var slot = swap_handler.selected_slot
	if slot and slot.equipment:
		var item = slot.equipment
		if RunManager.equipment.has(item):
			RunManager.equipment.erase(item)
			
		var hero = swap_handler._get_hero_from_slot(slot)
		if hero:
			hero.unequip(slot.equip_type_restriction)
			
		swap_handler._clear_selection()
		refresh()
		print("Discarded equipment: ", item.display_name if item.display_name else "Unknown")
	else:
		print("No equipment selected to discard.")
