extends Resource
class_name ReservoirState

var id: int
var parent: TeamState

var current_mana = 0.0 as float
var mult = 1.0 as float

## increases the reservoir's current mana. doesn't update the multiplier
func gain_mana(amount: float) -> ReservoirState:
	current_mana += amount
	current_mana = max(0, current_mana)
	return self

## updates the multiplier on the mana reservoir and returns it
func update_multiplier() -> ReservoirState:
	current_mana *= Defines.MANA_DECAY_TICK
	var level = _level_from_mana(current_mana)
	mult = level
	return self

func _mana_required_for_level(level: int) -> float:
	return Defines.MANA_LEVEL_BASE * pow(2.0, level - 1)

func _level_from_mana(mana: float) -> int:
	if mana <= 200.0:
		return 1
	var lvl := 1 + int(floor(log(mana / Defines.MANA_LEVEL_BASE) / log(2.0)))
	return lvl

func _to_string() -> String:
	return("Reservoir: " + str(id))
