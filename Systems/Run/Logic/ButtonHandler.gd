extends Node
class_name ButtonHandler

@onready var run_visuals: = %RunVisuals

enum ITEM_IDS {
	status_menu_button,
	perks_menu_button,
	equip_menu_button,
	shrines_menu_button,
	fighter_0,
	fighter_1,
	fighter_2,
	fighter_3,}
	
func _ready() -> void:
	EventBus.subscribe("item_activated", self)
	
func on_item_activated(item_id:ITEM_IDS) -> void:
	match item_id:
		ITEM_IDS.equip_menu_button:
			run_visuals.open_equipment_screen()
		ITEM_IDS.status_menu_button:
			get_tree().quit()
		ITEM_IDS.shrines_menu_button:
			run_visuals.open_level_selection_screen()
		ITEM_IDS.fighter_0:
			run_visuals.open_perk_tree(0)
		ITEM_IDS.fighter_1:
			run_visuals.open_perk_tree(1)
		ITEM_IDS.fighter_2:
			run_visuals.open_perk_tree(2)
		ITEM_IDS.fighter_3:
			run_visuals.open_perk_tree(3)
