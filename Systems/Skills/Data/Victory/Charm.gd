extends Skill
class_name Charm

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	var enemies = owner.get_enemy_team()
	enemies = enemies.fighters
	enemies = enemies.duplicate()
	enemies.erase(command.loser)
	Log.entry("won a clash and %s gets attacked by his team" % command.loser)
	return command
