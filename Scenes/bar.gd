@tool
extends Control

@onready var scaler = %Scaler

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		scaler.scale = Vector2.ONE / 2.0
		scaler.size = size * 2.0
