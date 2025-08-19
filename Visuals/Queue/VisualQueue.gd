extends Node
class_name VisualQueue

# An array to store the commands
var command_queue = [] as Array[VisualCMD]
var _current_command_index = 0 as int

# Add a command to the queue
func add_command(command):
	command_queue.append(command)

# Process a specified number of commands from the queue
func process_queue(num_commands: int = 1):
	var commands_to_process = min(num_commands, command_queue.size() - _current_command_index)
	for i in range(commands_to_process):
		var command = command_queue[_current_command_index]
		# For now, we'll just print the command
		print(command)
		_current_command_index += 1

# Reset the queue position for replays
func reset_queue_position():
	_current_command_index = 0
