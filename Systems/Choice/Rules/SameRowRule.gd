class_name SameRowRule
extends ChoiceRule

func conflicts(a, b):
	return a.data["row"] == b.data["row"]
