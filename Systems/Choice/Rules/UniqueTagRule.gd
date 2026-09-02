class_name UniqueTagRule
extends ChoiceRule

var tag := ""

func _init(_tag):

	tag = _tag


func conflicts(a, b):

	return a.tags.has(tag) and b.tags.has(tag)
