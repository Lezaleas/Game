class_name SameColumnRule
extends ChoiceRule

func conflicts(a, b):

	return a.data["column"] == b.data["column"]
