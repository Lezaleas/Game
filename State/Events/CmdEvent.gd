extends Resource
class_name CmdEvent

var type: Defines.CMD_EVENT_TYPE
var is_cancelled: bool = false

func _to_string():
	return ("CmdEvent: " + str(type))

# the parent class for all events. events are used as a data pack you can pass to the skill handler
# so it can alter it as needed and return it to the logical pipeline
