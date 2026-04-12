extends Resource
class_name EnemyData

@export var id: String
@export var sprite: SpriteFrames
@export var skills: Array[Skill] = [null,null,null,null]
@export var passives: Array[Skill] = [null,null,null,null]
@export var attributes_base = [10,10,10,10, 0,0,0,0,0,0,0]
@export var attributes_mult = [1,1,1,1, 1,1,1,1,1,1,1]
