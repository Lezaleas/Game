extends Resource
class_name AttributeState

var id: int
var parent: FighterState

var base: float = 10
var mult: float = 1
var current: float = 10
var up_to_date: float = true

## updates the attribute current value
func update() -> AttributeState:
	if not up_to_date:
		current = base * mult
		up_to_date = true
	return self

## increases the multiplier on the attribute
func increase_mult(increase: float) -> AttributeState:
	mult += increase
	up_to_date = false
	return self

## increases the base power on the attribute
func increase_base(increase: float) -> AttributeState:
	base += increase
	up_to_date = false
	return self

func _to_string() -> String:
	return("Attribute: " + str(id))
