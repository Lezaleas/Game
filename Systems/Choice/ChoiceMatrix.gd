class_name ChoiceMatrix
extends RefCounted

var width := 0
var height := 0
var nodes: Array[Array] = []

func _init(contents: Array = []):
	if !contents.is_empty():
		build(contents)

func build(contents: Array):
	height = contents.size()
	if height == 0: return
	width = contents[0].size()
	nodes.clear()

	for row in height:
		var matrix_row: Array[ChoiceNode] = []
		for column in width:
			var node := ChoiceNode.new()
			node.payload = contents[row][column]
			node.data["row"] = row
			node.data["column"] = column
			matrix_row.append(node)

		nodes.append(matrix_row)

func get_node(row: int, column: int) -> ChoiceNode:
	return nodes[row][column]

func get_row(row: int) -> Array:
	return nodes[row]

func get_column(column: int) -> Array:
	var result := []
	for row in height:
		result.append(nodes[row][column])
	return result
	
func get_all_nodes() -> Array[ChoiceNode]:
	var result: Array[ChoiceNode] = []
	for row in nodes:
		result.append_array(row)
	return result
