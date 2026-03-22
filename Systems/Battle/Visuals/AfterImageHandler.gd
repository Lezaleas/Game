extends Node

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var fighter: FighterView = $".."

@export var spawn_interval := 0.03
@export var lifetime := 0.20

var _timer := 0.0

func _process(delta):
	if not fighter.spawn_afterimages: return
	
	_timer += delta
	if _timer >= spawn_interval/Situation.anim_speed:
		_timer = 0.0
		_spawn_afterimage()


func _spawn_afterimage():
	var ghost := Sprite2D.new()
	
	# Get current frame texture
	var texture := sprite.sprite_frames.get_frame_texture(
		sprite.animation,
		sprite.frame
	)
	
	ghost.texture = texture
	ghost.global_position = sprite.global_position
	ghost.scale = sprite.scale
	ghost.flip_h = sprite.flip_h
	
	# Visual setup
	ghost.modulate = Color(1, 1, 1, 0.6)
	ghost.z_index = sprite.z_index - 1
	
	get_tree().current_scene.add_child(ghost)
	
	_fade_and_free(ghost)


func _fade_and_free(ghost: Sprite2D):
	var tween := create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, lifetime/Situation.anim_speed)
	tween.tween_callback(ghost.queue_free)
