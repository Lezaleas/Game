# RunManager
extends Node

var run_seed: int
var run_rng: RandomNumberGenerator = RandomNumberGenerator.new()
var run: RunState
var shrines: Array[PerkTree]
var heroes: Array[HeroState]
var equipment: Array[EquipmentState]
var loaded_run: RunState

@export var skill_pools: Dictionary = {
	Defines.PROG_TAG.Smithing: [] as Array[Skill],
	Defines.PROG_TAG.Warfare: [] as Array[Skill],
	Defines.PROG_TAG.Arcane: [] as Array[Skill],
	Defines.PROG_TAG.Learning: [] as Array[Skill],
	Defines.PROG_TAG.Crafting: [] as Array[Skill],
	Defines.PROG_TAG.Stewardry: [] as Array[Skill],
	Defines.PROG_TAG.Charisma: [] as Array[Skill],
	Defines.PROG_TAG.Wildcraft: [] as Array[Skill]
}

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

	# Initialize skill pools if empty
	if skill_pools[Defines.PROG_TAG.Smithing].is_empty():
		skill_pools[Defines.PROG_TAG.Smithing] = [load("res://Systems/Skills/Data/FrostShield.tres")] as Array[Skill]
	if skill_pools[Defines.PROG_TAG.Warfare].is_empty():
		skill_pools[Defines.PROG_TAG.Warfare] = [load("res://Systems/Skills/Data/Berserk.tres"), load("res://Systems/Skills/Data/Anger.tres")] as Array[Skill]
	if skill_pools[Defines.PROG_TAG.Arcane].is_empty():
		skill_pools[Defines.PROG_TAG.Arcane] = [load("res://Systems/Skills/Data/Focus.tres"), load("res://Systems/Skills/Data/ShadowCast.tres")] as Array[Skill]
	if skill_pools[Defines.PROG_TAG.Learning].is_empty():
		skill_pools[Defines.PROG_TAG.Learning] = [load("res://Systems/Skills/Data/Monk.tres")] as Array[Skill]
	if skill_pools[Defines.PROG_TAG.Crafting].is_empty():
		skill_pools[Defines.PROG_TAG.Crafting] = [load("res://Systems/Skills/Data/Block.tres")] as Array[Skill]
	if skill_pools[Defines.PROG_TAG.Stewardry].is_empty():
		skill_pools[Defines.PROG_TAG.Stewardry] = [load("res://Systems/Skills/Data/Sergeant.tres")] as Array[Skill]
	if skill_pools[Defines.PROG_TAG.Charisma].is_empty():
		skill_pools[Defines.PROG_TAG.Charisma] = [load("res://Systems/Skills/Data/Charm.tres")] as Array[Skill]
	if skill_pools[Defines.PROG_TAG.Wildcraft].is_empty():
		skill_pools[Defines.PROG_TAG.Wildcraft] = [load("res://Systems/Skills/Data/Ranger.tres"), load("res://Systems/Skills/Data/Rogue.tres")] as Array[Skill]
