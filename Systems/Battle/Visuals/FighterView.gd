extends Node2D
class_name FighterView

@onready var sprite: AnimatedSprite2D = %Sprite
var fighter_state: FighterState
var id = 0 as int
var current_speed: float = 1.0
var hit_flash_tween: Tween
var move_tween: Tween
var last_x: float = 0.0
var lock_count: int = 0
var spawn_afterimages: = false

func _ready():
	add_to_group("refresh")
	EventBus.subscribe("game_speed_changed", self, "_on_game_speed_changed")
	
func refresh_battle_started():
	fighter_state = Situation.fighters[id]
	sprite.sprite_frames = fighter_state.sprite
	self.position.y = fighter_state.position_y
	self.position.x = fighter_state.position_x
	last_x = fighter_state.position_x
	sprite.play("default")

func refresh(_delta):
	if not sprite.is_playing():
		sprite.play("default")
		
	if lock_count <= 0:
		var target_x = fighter_state.position_x
		if target_x != last_x:
			last_x = target_x
			if move_tween: move_tween.kill()
			move_tween = create_tween()
			move_tween.set_speed_scale(current_speed)
			# Duration set to match roughly one turn or a quick slide. 0.2 is the default turn duration.
			move_tween.tween_property(self, "position:x", target_x, 0.2)

func lock_movement() -> void:
	lock_count += 1

func unlock_movement() -> void:
	lock_count -= 1
	if lock_count <= 0:
		lock_count = 0
		# Force an update so it catches up immediately if position changed
		#refresh(0)

func play_magic_animation() -> void:
	AudioBus.play_sound("magic")
	if sprite.sprite_frames.has_animation("magic"):
		sprite.play("magic")
	else:
		push_warning("Animation 'magic' not found")

func play_damaged_animation() -> void:
	AudioBus.play_sound("damaged")
	if sprite.sprite_frames.has_animation("damaged"):
		sprite.play("damaged")
	else:
		push_warning("Animation 'damaged' not found")
	# Flash red for hit effect
	if hit_flash_tween: hit_flash_tween.kill()
	hit_flash_tween = create_tween()
	hit_flash_tween.set_speed_scale(current_speed)
	hit_flash_tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	hit_flash_tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
func play_clashing_animation() -> void:
	if sprite.sprite_frames.has_animation("clashing"):
		sprite.play("clashing")
	else:
		push_warning("Animation 'clashing' not found")

func _on_game_speed_changed(_speed: float) -> void:
	current_speed = Situation.anim_speed
	sprite.speed_scale = current_speed
	if hit_flash_tween and hit_flash_tween.is_valid():
		hit_flash_tween.set_speed_scale(current_speed)
	if move_tween and move_tween.is_valid():
		move_tween.set_speed_scale(current_speed)
