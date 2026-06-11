extends Resource
class_name FighterState

var id: int
var parent: TeamState
var attributes: Array[AttributeState]
var skills = [] as Array[Skill]
var stamina: int = 100
var position_x: float = 0.0
var position_y: int = 0
var direction: int = 1
var dmg_del = 0 as float
var dmg_rec = 0 as float
var clash_won = 0 as int
var clash_fought = 0 as int
var buffs: BuffsState
var element: int = 0
var view: FighterView
var sprite: SpriteFrames
var clashed := false
var enemy_data: EnemyData

func setup():
	buffs = BuffsState.new(self)
	position_x = 480 + 760 * parent.id + id * 50
	position_y = 315 + 60 * (id - parent.id * 4)
	direction = parent.direction
	
func gain_stamina(amount: float):
	stamina = clamp(stamina + amount, 0, 100)
	
func jump(amount: float):
	position_x += amount * direction

func apply_buff(buff_id: Defines.BUFF, amount: float, applier: FighterState = null):
	var buff = Defines.buffs.get_buff(buff_id) as Buff
	buffs.apply_buff(buff, amount, applier)

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

## Returns true if the other fighter is an ally (same team, but not self)
func are_allied(other: FighterState) -> bool:
	return self != other and self.parent == other.parent

## returns the opposite team resource
func get_enemy_team() -> TeamState:
	for team in parent.parent.teams:
		if self.parent != team:
			return team
	push_error("wrong return")
	return

## returns the allied team resource
func get_allied_team() -> TeamState:
	return parent

func _to_string() -> String:
	return("Fighter: " + str(id))
