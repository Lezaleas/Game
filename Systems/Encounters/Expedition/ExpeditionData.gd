class_name ExpeditionData
extends LevelData

@export var player_preset_creatures: Array[HeroState]
@export var enemy_preset_creatures: Array[EnemyData]
@export var enemy_draft_pool: Array[EnemyData]
var player_draft_pool: Array[HeroState]

func receive_player_team(_player_team:Array[HeroState]) -> LevelData:
	player_draft_pool = _player_team.duplicate(true)
	battle_type = BattleState.BattleType.EXPEDITION
	#var reward := RitualAscensionReward.new()
	#level.rewards.append(reward)
	return self
