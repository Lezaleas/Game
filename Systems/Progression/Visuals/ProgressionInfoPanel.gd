extends PanelContainer
class_name ProgressionInfoPanel

@onready var title_label = %TitleLabel
@onready var desc_label = %DescLabel
@onready var details_vbox = %DetailsVBox

func _ready() -> void:
	EventBus.subscribe("progression_hover", self)
	clear_info()

func on_progression_hover(data) -> void:
	if data == null:
		clear_info()
		return
		
	if data is Villager:
		show_villager_info(data)
	elif data is Room:
		show_room_info(data)
	elif data is Building:
		show_building_info(data)

func clear_info() -> void:
	title_label.text = "Select something"
	desc_label.text = "Hover over a villager or room to see details."
	for child in details_vbox.get_children():
		child.queue_free()

func show_villager_info(villager: Villager) -> void:
	title_label.text = villager.name
	desc_label.text = villager.description if villager.description != "" else "A hard-working villager."
	
	for child in details_vbox.get_children():
		child.queue_free()
		
	_add_detail("Method", Defines.PROG_METHOD.keys()[villager.method])
	_add_detail("Personality", Defines.PROG_PERSONALITY.keys()[villager.personality])
	
	var tags_header = Label.new()
	tags_header.text = "\nTags:"
	tags_header.modulate = Color.AQUAMARINE
	details_vbox.add_child(tags_header)
	
	for tag in villager.tags:
		_add_detail(Defines.PROG_TAG.keys()[tag], str(villager.tags[tag]))

func show_room_info(room: Room) -> void:
	title_label.text = room.room_name
	desc_label.text = room.description if room.description != "" else "A specialized production room."
	
	for child in details_vbox.get_children():
		child.queue_free()
		
	_add_detail("Element", Defines.PROG_ELEMENT.keys()[room.element])
	_add_detail("Base Effect", room.base_effect)
	
	if not room.thresholds.is_empty():
		var thresh_header = Label.new()
		thresh_header.text = "\nThresholds:"
		thresh_header.modulate = Color.ORANGE
		details_vbox.add_child(thresh_header)
		# ... detail thresholds ...

func show_building_info(building: Building) -> void:
	title_label.text = building.building_name
	desc_label.text = building.description
	
	for child in details_vbox.get_children():
		child.queue_free()
	
	_add_detail("Specialization", building.specialization)

func _add_detail(key: String, value: String) -> void:
	var label = Label.new()
	label.text = "%s: %s" % [key, value]
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	details_vbox.add_child(label)
