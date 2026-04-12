# RunManager
extends Node

var run_seed: int
var run_rng: RandomNumberGenerator = RandomNumberGenerator.new()
var run: RunState
var shrines: Array[PerkTree]
var heroes: Array[HeroState]
var equipment: Array[EquipmentState]
var loaded_run: RunState

func _ready() -> void:
	equipment = [
	load("res://Systems/Equipment/Data/Sword_1.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Sword_2.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Sword_3.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Sword_4.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Staff_1.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Staff_2.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Staff_3.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Staff_4.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Armor_1.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Armor_2.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Armor_3.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Armor_4.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Boots_1.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Boots_2.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Boots_3.tres").duplicate(true),
	load("res://Systems/Equipment/Data/Boots_4.tres").duplicate(true)]
