extends Resource
class_name DraftState

@export var turn_order = [0, 1, 0]
var player_team: Array[HeroState]
var enemy_team: Array[EnemyData]
var player_pool: Array[HeroState]
var enemy_pool: Array[EnemyData]
var exp_data: ExpeditionData

func take_expedition_data(expedition_data: ExpeditionData) -> void:
	exp_data = expedition_data
	player_team = exp_data.player_preset_creatures
	player_pool = exp_data.player_draft_pool
	enemy_team = exp_data.enemy_preset_creatures
	enemy_pool = exp_data.enemy_draft_pool
	
func pick_creature(creature: Variant):
	if creature in player_pool:
		player_team.append(creature)
		player_pool.erase(creature)
	elif creature in enemy_pool:
		enemy_team.append(creature)
		enemy_pool.erase(creature)
		
func resolve_draft() -> ExpeditionData:
	for active_side in turn_order:
		resolve_turn(active_side)
	exp_data.player_team = player_team
	exp_data.array_to_enemies(enemy_team)
	return exp_data

func resolve_turn(active_side: int):
	if active_side == 0:
		player_draft()
	else:
		enemy_draft()
