extends Resource
class_name LevelData

@export var id: String
@export var enemy0: EnemyData
@export var enemy1: EnemyData
@export var enemy2: EnemyData
@export var enemy3: EnemyData
@export var rewards: Array[LevelReward] = []
@export var modifier = null
@export var prerequisite: LevelData
var cleared: bool = false
