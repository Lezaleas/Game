extends Node

const MAGIC = preload("res://Data/Assets/Sfx/Ice4.ogg")
const DAMAGED = preload("res://Data/Assets/Sfx/damaged.wav")

@onready var players = get_children()

func play_sound(sound_name: String) -> void:
	var stream: AudioStream
	match sound_name:
		"magic":
			stream = MAGIC
		"damaged":
			stream = DAMAGED
		_:
			push_warning("AudioBus: Unknown sound name '%s'" % sound_name)
			return

	# Find a free player
	for player in players:
		if player.playing:
			if player.stream == stream: return
			
	for player in players:
		if not player.playing:
			player.stream = stream
			player.play()
			return
	
	# If all busy, use the first one (cut off) or just ignore? 
	# Let's use the first one for now to ensure feedback, or maybe random?
	# Simple approach: interrupt first one.
	if players.size() > 0:
		var p = players[0]
		p.stream = stream
		p.play()
