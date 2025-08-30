extends Resource
class_name FighterState

var id: int
var parent: TeamState
var attributes: Array[AttributeState]
var skills = [] as Array[Skill]
var stamina: int = 100
var position_x: float = 0.0
var position_y: int = 0
var team_id: int = 1
var dmg_del = 0 as float
var dmg_rec = 0 as float
var clash_won = 0 as int
var clash_fought = 0 as int

func setup():
	position_x = 480 + 960 * parent.id
	position_y = 315 + 60 * (id - parent.id * 4)

## receives a fighter and returns the previous fighter in the same team
func get_previous_fighter() -> FighterState:
	var fighters = parent.fighters
	var index := id as int
	var prev_index := (index - 1 + fighters.size()) % fighters.size() as int
	return fighters[prev_index]

## receives a fighter and returns the next fighter in the same team
func get_next_fighter() -> FighterState:
	var fighters = parent.fighters
	var index := id as int
	var next_index := (index + 1) % fighters.size() as int
	return fighters[next_index]

## Returns true if the other fighter is an ally
func are_allied(other: FighterState) -> bool:
	return self.team == other.team

##  returns the opposite team resource
func get_enemy_team() -> TeamState:
	for team in parent.parent.teams:
		if self.parent != team:
			return team
	push_error("wrong return")
	return

##  returns the allied team resource
func get_allied_team() -> TeamState:
	return parent

func _to_string() -> String:
	return("Fighter: " + str(id))
