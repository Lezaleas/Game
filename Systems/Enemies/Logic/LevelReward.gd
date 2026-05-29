extends Resource
class_name LevelReward

# Base class for level rewards.
# Subclasses should override apply_reward() and get_description() to customize behaviors.

func apply_reward() -> void:
	pass

func get_description() -> String:
	return "Generic Reward"
