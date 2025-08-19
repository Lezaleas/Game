# log_game_event.gd
# Description: Logs game events to a text file.

@tool
extends EditorScript

var log_file_path = "res://Logs/game_log.txt"

func _run():
    var args = OS.get_cmdline_args()
    if args.size() > 0:
        var event_data = args[0]
        log_event(event_data)
    else:
        push_warning("No event data provided to log_game_event skill.")

func log_event(event_data: String):
    var file = FileAccess.open(log_file_path, FileAccess.WRITE_READ)
    if file:
        file.store_string(event_data + "\n")
        file.close()
        print("Logged event: " + event_data)
    else:
        push_warning("Could not open log file: " + log_file_path)