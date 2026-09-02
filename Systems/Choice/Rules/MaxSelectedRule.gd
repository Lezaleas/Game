class_name MaxSelectedRule
extends ChoiceRule

var amount := 1

func _init(n):

	amount = n


func can_finish(session):

	return session.selected.size() == amount
