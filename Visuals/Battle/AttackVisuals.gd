extends Node

const PROJECTILE_SCENE = preload("res://Visuals/Battle/Projectile.tscn")

func _ready() -> void:
	EventBus.subscribe("battle_action_cast", self, "_on_battle_action_cast")

func _on_battle_action_cast(data: Dictionary) -> void:
	var caster_state = data.caster as FighterState
	var targets = data.targets as Array
	
	# Play caster animation
	var caster_view = caster_state.view
	if caster_view:
		caster_view.play_magic_animation()
	
	# Spawn projectiles
	for target_state in targets:
		var target_view = target_state.view
		target_view.lock_movement()
		var projectile = PROJECTILE_SCENE.instantiate()
		add_child(projectile)
		# Offset projectile start to handle sprite size? 
		projectile.setup(caster_view.position, target_view, func(): _on_projectile_hit(target_view))

func _on_projectile_hit(target_view) -> void:
	if target_view:
		target_view.unlock_movement()
		target_view.play_damaged_animation()
