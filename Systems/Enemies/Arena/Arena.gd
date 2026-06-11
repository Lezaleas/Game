extends Node
class_name Arena

const WAVE_REWARD = [3,4,5,6,8,10,12,16,20,24,32,40,48]

var current_wave: int
var current_encounter: LevelData

func start_arena() -> void:
	current_wave = max(0, RunManager.arena_record - Defines.ARENA_OFFSET)
	EventBus.subscribe("battle_won", self)
	start_next_wave()

func start_next_wave() -> void:
	current_wave += 1
	current_encounter = generate_wave()
	Situation.start_battle(current_encounter)

func generate_wave() -> LevelData:
	var tier: int = mini(3, current_wave / 5)
	var position_in_tier: int = (current_wave - 1) % 5
	var enemy_team: Array[EnemyData] = []
	while true:
		enemy_team.clear()
		match position_in_tier:
			0:
				enemy_team.append_array(_pick_random_enemies(tier, 4))

			1:
				enemy_team.append_array(_pick_random_enemies(tier, 3))
				enemy_team.append_array(_pick_random_enemies(tier + 1, 1))

			2:
				enemy_team.append_array(_pick_random_enemies(tier, 2))
				enemy_team.append_array(_pick_random_enemies(tier + 1, 2))

			3:
				enemy_team.append_array(_pick_random_enemies(tier, 1))
				enemy_team.append_array(_pick_random_enemies(tier + 1, 3))

			4:
				enemy_team.append_array(_pick_random_enemies(tier + 1, 4))
		if _encounter_validated(enemy_team):
			break
	var level := LevelData.new()
	level.battle_type = BattleState.BattleType.ARENA
	level.array_to_enemies(enemy_team)
	return level

func _pick_random_enemies(tier: int, amount: int) -> Array[EnemyData]:
	tier = clampi(tier, 0, 3)
	var registry: Array[EnemyData] = Utils.get_enemy_registry(tier)
	var result: Array[EnemyData] = []
	for i in range(amount):
		result.append(registry.pick_random())
	return result

func _encounter_validated(enemy_team) -> bool:
	const FIGHTER = [0, 4, 5, 6]
	const MAGE = [1, 4, 7, 8]
	const TANK = [2, 3, 5, 6, 7, 8]
	var fighter_found := false
	var mage_found := false
	var tank_found := false
	for enemy in enemy_team:
		if enemy.role in FIGHTER:
			fighter_found = true
		if enemy.role in MAGE:
			mage_found = true
		if enemy.role in TANK:
			tank_found = true
	return fighter_found and mage_found and tank_found

func on_battle_won(team_id) -> void:
	if team_id == 0:
		start_next_wave()
		return
	RunManager.arena_record = max(RunManager.arena_record, current_wave)
	var rewards = generate_rewards(current_wave)
	for item in rewards:
		RunManager.equipment.append(item)
	Situation.clear_state_generic()
	RunManager.get_tree().change_scene_to_file("res://Systems/Run/Logic/RunScene.tscn")
	queue_free()

func generate_rewards(wave: int) -> Array:
	var rewards: Array = []
	var skill_seed = [0,0,0,0,0,0,0,0]
	var first = randi_range(0, 7)
	var second = first
	while second == first:
		second = randi_range(0, 7)
	skill_seed[first] = 1
	skill_seed[second] = 1
	for x in range(8):
		var get_skill = skill_seed[x]
		var quality = WAVE_REWARD[wave]
		rewards.append(EquipmentGenerator.generate_item(quality, x % 4, get_skill))
	return rewards
