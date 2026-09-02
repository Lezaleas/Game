extends Resource
class_name LevelData

@export var id: String = "Level"
@export var enemy0: EnemyData
@export var enemy1: EnemyData
@export var enemy2: EnemyData
@export var enemy3: EnemyData
@export var rewards: Array[LevelReward] = []
var battle_type: BattleState.BattleType = BattleState.BattleType.HUNT
var cleared: bool = false
var player_team :Array[HeroState] = []

func _to_string() -> String:
	var ids := [enemy0,enemy1,enemy2,enemy3].map(func(enemy): return enemy.id if enemy else "null")
	return "LevelData: %s" % ", ".join(ids)

func array_to_enemies(enemies: Array[EnemyData]) -> void:
	assert(enemies.size() == 4, "array_to_enemies requires exactly 4 enemies")
	enemy0 = enemies[0]
	enemy1 = enemies[1]
	enemy2 = enemies[2]
	enemy3 = enemies[3]
