extends Button

var fighter_id: int

func _ready() -> void:
	EventBus.subscribe("battle_won", self)
	pressed.connect(_on_pressed)
	
func on_battle_won(team_id:int) -> void:
	if fighter_id < Defines.TEAM_SIZE:
		queue_free()
	if team_id == 0:
		show()

func _on_pressed() -> void:
	EventBus.emit("capture_requested", fighter_id)
