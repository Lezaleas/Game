@tool
extends EditorScript

# Folder to scan
var target_folder := "res://Data/Skills"

func _run():
	print("Starting Skill files update...")
	_update_files_in_folder(target_folder)
	print("Skill files update completed!")

func _update_files_in_folder(folder_path: String):
	var dir = DirAccess.open(folder_path)
	if dir == null:
		push_error("Cannot open folder: %s" % folder_path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
		
		var full_path = folder_path + "/" + file_name
		
		if dir.current_is_dir():
			_update_files_in_folder(full_path)
		elif file_name.ends_with(".gd"):
			_update_file(full_path)
		
		file_name = dir.get_next()
	dir.list_dir_end()

func _update_file(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Cannot open file: %s" % file_path)
		return
	
	var lines = []
	while not file.eof_reached():
		lines.append(file.get_line())
	file.close()
	
	# Get the file name without extension
	var kclass_name = file_path.get_file().get_basename()
	if kclass_name == "Skill":
		return
	
	# Ensure at least 2 lines
	if lines.size() < 2:
		lines.resize(2)
	
	lines[0] = "@icon(\"res://Data/Assets/Sprites/Common/ElementalIcons/Purple.tres\")"
	lines[1] = "extends Skill"
	lines[2] = "class_name " + kclass_name
	
	# Rewrite the file
	file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		push_error("Cannot write file: %s" % file_path)
		return
	
	for line in lines:
		file.store_line(line)
	file.close()
	print("Updated: %s" % file_path)
