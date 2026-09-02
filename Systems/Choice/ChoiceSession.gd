class_name ChoiceSession
extends RefCounted

signal changed
signal confirmed
var nodes : Array[ChoiceNode] = []
var rules : Array[ChoiceRule] = []
var selected : Array[ChoiceNode] = []

func toggle(node: ChoiceNode):
	if selected.has(node):
		selected.erase(node)
	else:
		if node.state == ChoiceNode.State.BLOCKED:
			return
		selected.append(node)

	update_states()
	changed.emit()

func update_states():
	for node in nodes:
		node.state = ChoiceNode.State.AVAILABLE
	for node in selected:
		node.state = ChoiceNode.State.SELECTED
		
	for node in nodes:
		if node.state == ChoiceNode.State.SELECTED: continue
		for chosen in selected:
			var blocked := false
			for rule in rules:
				if rule.conflicts(chosen, node):
					blocked = true
					break
			if blocked:
				node.state = ChoiceNode.State.BLOCKED
				break

func can_confirm():
	for rule in rules:
		if !rule.can_finish(self):
			return false
	return true

func confirm():
	if !can_confirm(): return
	for node in selected:
		if node.resolver:
			node.resolver.resolve(node)
	confirmed.emit()
