extends Node

var _signals: Dictionary = {}

# Ensure a signal exists
func _ensure_signal(event_name: String) -> void:
	if not has_user_signal(event_name):
		# Always define one argument, "data", which can be null or anything
		add_user_signal(event_name, ["data"])
		_signals[event_name] = true

# Subscribe
func subscribe(event_name: String, target: Object, method_name: String = "") -> void:
	_ensure_signal(event_name)

	if method_name == "":
		method_name = "on_" + event_name

	if not is_instance_valid(target):
		return

	var callable := Callable(target, method_name)
	if not is_connected(event_name, callable):
		connect(event_name, callable)

# Subscribe many
func subscribe_many(events: Array[String], targets: Array[Object], method_name: String = "") -> void:
	for target in targets:
		for event in events:
			subscribe(event, target, method_name)

# Unsubscribe
func unsubscribe(event_name: String, target: Object, method_name: String = "") -> void:
	if method_name == "":
		method_name = "on_" + event_name

	if has_user_signal(event_name) and is_instance_valid(target):
		var callable := Callable(target, method_name)
		if is_connected(event_name, callable):
			disconnect(event_name, callable)

# Emit event
func emit(event_name: String, data = null) -> void:
	if has_user_signal(event_name):
		if data:
			emit_signal(event_name, data)
		else:
			emit_signal(event_name)
