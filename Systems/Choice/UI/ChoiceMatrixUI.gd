class_name ChoiceMatrixUI
extends Control

signal confirmed
var session : ChoiceSession
var matrix : ChoiceMatrix
var buttons := {}
@onready var grid_container: GridContainer = %GridContainer

func setup(choice_session, choice_matrix):
	var buttongs = [[ChoiceNode.new(),ChoiceNode.new()],[ChoiceNode.new(),ChoiceNode.new()]]
	var choice_matrixs = ChoiceMatrix.new(buttongs)
	var nodus = choice_matrix.get_all_nodes()
	var choice_sessions = ChoiceSession.new()
	choice_sessions.nodes = nodus
	print(choice_matrixs.get_all_nodes())
	print("got here")
	session = choice_sessions
	matrix = choice_matrixs
	grid_container.columns = matrix.width
	build()
	session.changed.connect(refresh)
	
func build():
	for child in grid_container.get_children():
		child.queue_free()
	buttons.clear()
	for node in matrix.get_all_nodes():
		var button: = preload("res://Systems/Choice/UI/ChoiceNodeButton.tscn").instantiate()
		grid_container.add_child(button)
		button.setup(node)
		button.clicked.connect(session.toggle)
		buttons[node] = button

func refresh():
	for button in buttons.values():
		button.refresh()

func _on_confirm_pressed():
	session.confirm()
