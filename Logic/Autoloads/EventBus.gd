extends Node

var _signals: Dictionary = {}
var _subscriptions: Dictionary = {} # Stores subscriptions with priorities

# Ensure a signal exists
func _ensure_signal(event_name: String) -> void:
	if not has_user_signal(event_name):
		# Event data will now be a BaseEvent object
		add_user_signal(event_name, ["event"])
		_signals[event_name] = true
		_subscriptions[event_name] = []

# Subscribe
func subscribe(event_name: String, target: Object, method_name: String = "", priority: int = 0) -> void:
	_ensure_signal(event_name)

	if method_name == "":
		method_name = "on_" + event_name

	if not is_instance_valid(target):
		return

	var callable := Callable(target, method_name)
	if not is_connected(event_name, callable):
		# Store callable and its priority
		_subscriptions[event_name].append({"callable": callable, "priority": priority})
		# Sort subscriptions by priority (highest first)
		_subscriptions[event_name].sort_custom(func(a, b): return a.priority > b.priority)
		# Connect the signal
		connect(event_name, callable)

# Subscribe many
func subscribe_many(events: Array[String], targets: Array[Object], method_name: String = "", priority: int = 0) -> void:
	for target in targets:
		for event in events:
			subscribe(event, target, method_name, priority)

# Unsubscribe
func unsubscribe(event_name: String, target: Object, method_name: String = "") -> void:
	if method_name == "":
		method_name = "on_" + event_name

	if has_user_signal(event_name) and is_instance_valid(target):
		var callable := Callable(target, method_name)
		if is_connected(event_name, callable):
			disconnect(event_name, callable)
			# Remove from our custom subscriptions list
			var to_remove = -1
			for i in range(_subscriptions[event_name].size()):
				if _subscriptions[event_name][i].callable == callable:
					to_remove = i
					break
			if to_remove != -1:
				_subscriptions[event_name].remove_at(to_remove)

# Emit event
func emit(event_name: String, event: BaseEvent = null) -> void:
	if not has_user_signal(event_name):
		return

	if event == null:	# send a signal without parameters
		emit_signal(event_name)
		return

	# Emit to listeners in priority order
	for sub in _subscriptions[event_name]:
		if event.is_cancellable and event.is_cancelled:
			break # Stop if event is cancelled

		# Directly call the method instead of emitting the signal,
		# so we can control the flow based on cancellation.
		# This also ensures that the 'event' object is passed by reference
		# and modifications are visible to subsequent listeners.
		sub.callable.call(event)

	# If the event was originally a signal, emit it for any remaining connections
	# (e.g., from the editor or other non-priority-controlled connections)
	# This might be redundant if all connections are managed by subscribe/unsubscribe
	# but provides a fallback.
	if has_user_signal(event_name):
		emit_signal(event_name, event)
