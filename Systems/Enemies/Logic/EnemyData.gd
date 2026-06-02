@tool
extends Resource
class_name EnemyData

@export var id: String
@export var skills: Array[Skill] = [null,null,null,null]
@export var passives: Array[Skill] = [null,null,null,null]
@export var attributes_base = [10,10,10,10, 0,0,0,0,0,0,0]
@export var attributes_mult = [1,1,1,1, 1,1,1,1,1,1,1]
@export var sprite: SpriteFrames:
	set(value):
		sprite = value
		_update_icon()

@export var icon : Texture2D
@export var role: Defines.ENEMY_ROLES = Defines.ENEMY_ROLES.SP

func _update_icon():
	if sprite == null:
		return

	if not sprite.has_animation("default"):
		return

	var anim = "default"

	if sprite.get_frame_count(anim) == 0:
		return

	icon = sprite.get_frame_texture(anim, 0)
