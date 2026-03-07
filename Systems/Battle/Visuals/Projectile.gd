extends Node2D

var speed = 5.0 # Speed factor. Higher means the projectile reaches the destination faster.
var adjusted_speed := false
var target_node: Node2D
var callback: Callable

# Called to initialize the projectile.
# start_pos: Global position where the projectile starts.
# target: The node it moves towards.
# on_hit: Function to call when it reaches the target.
func setup(start_pos: Vector2, target: Node2D, on_hit: Callable) -> void:
	position = start_pos
	target_node = target
	callback = on_hit
	speed *= Situation.game_speed
	set_process(true)

func _process(delta: float) -> void:
	# Safety check: if target died/disappeared, destroy projectile.
	if not is_instance_valid(target_node):
		queue_free()
		return
	
	var direction = (target_node.position - position).normalized()
	var distance_to_target = position.distance_to(target_node.position)
	var step = speed * delta
	if not adjusted_speed:
		adjusted_speed = true
		speed *= distance_to_target
	
	# Check if we are close enough to "hit" the target this frame (including a small margin for float errors if needed, but step logic handles it).
	# Logic: If the amount we would move (step) is greater than the distance remaining, we have arrived.
	if distance_to_target <= step:
		position = target_node.position
		_on_reached_target()
	else:
		position += direction * step

# Logic for when the projectile hits.
func _on_reached_target() -> void:
	# Trigger the damage/effect callback provided in setup().
	if callback.is_valid():
		callback.call()
	queue_free()
