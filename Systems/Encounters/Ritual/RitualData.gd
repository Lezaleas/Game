class_name RitualData
extends LevelData

@export var champion_buff: Skill
@export var team_debuff: Skill

func receive_player_team(_player_team:Array[HeroState]) -> LevelData:
	player_team = _player_team.duplicate(true)
	battle_type = BattleState.BattleType.RITUAL
	for hero in player_team:
		if hero.id == 0:
			if champion_buff:
				hero.grant_skill(champion_buff)
		else:
			if team_debuff:
				hero.grant_skill(team_debuff)
	#var reward := RitualAscensionReward.new()
	#level.rewards.append(reward)
	return self
