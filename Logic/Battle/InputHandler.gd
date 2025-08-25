extends Node
class_name InputHandler

# Query functions for current state
func is_1_pressed() -> bool:
	return Input.is_action_pressed("1")

# Process raw input events and emit signals
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_game"): get_tree().quit()
	if event.is_action_pressed("1"): EventBus.emit("move_right_pressed")
	if event.is_action_released("1"): EventBus.emit("1_released")
	if event.is_action_pressed("2"): EventBus.emit("move_up_pressed")
	if event.is_action_released("2"): EventBus.emit("2_released")
	if event.is_action_pressed("3"): EventBus.emit("move_down_pressed")
	if event.is_action_released("3"): EventBus.emit("3_released")
	if event.is_action_pressed("4"): EventBus.emit("jump_pressed")
	if event.is_action_released("4"): EventBus.emit("4_released")
