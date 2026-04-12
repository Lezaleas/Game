extends Node
class_name PerkController

func _ready() -> void:
	EventBus.subscribe("request_perk_unlock", self)
	EventBus.subscribe("request_perk_remove", self)
	
func on_request_perk_unlock(perk:Perk) -> void:
	var hero_id = perk.hero_id
	perk.unlocked = true
	RunManager.heroes[hero_id].unlock_perk(perk)

func on_request_perk_remove(perk:Perk) -> void:
	var hero_id = perk.hero_id
	perk.unlocked = false
	RunManager.heroes[hero_id].remove_perk(perk)
