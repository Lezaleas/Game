class_name ChoiceRule
extends RefCounted

@warning_ignore("unused_parameter")
func conflicts(a: ChoiceNode, b: ChoiceNode) -> bool:
	return false


@warning_ignore("unused_parameter")
func can_finish(session) -> bool:
	return true
