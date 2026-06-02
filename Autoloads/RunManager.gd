# RunManager
extends Node

enum RunLoadMode {NEW_RUN,RESUME_RUN,LOAD_SAVE}

var load_mode: RunLoadMode = RunLoadMode.NEW_RUN
var run_seed: int
var run_rng: RandomNumberGenerator = RandomNumberGenerator.new()
var run: RunState
var shrines: Array[PerkTree]
var heroes: Array[HeroState]
var equipment: Array[EquipmentState]
var buildings: Array[Building]
var villagers: Array[Villager]
var reserve_villagers: Array[Villager]
var loaded_run: RunState
var levels: Array[LevelData] = []

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

	if levels.is_empty():
		reset_levels()

	# Initialize skill pools if empty
	var all_empty = true
	for pool in skill_pools.values():
		if not pool.is_empty():
			all_empty = false
			break
	
	if all_empty:
		reset_skill_pools()
		
	if buildings.is_empty():
		reset_progression_data()

func reset_levels() -> void:
	levels = [
		(load("res://Systems/Enemies/LevelData/Stage0/11.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage0/12.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage0/13.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage0/14.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage1/21.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage1/22.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage1/23.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage1/24.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage2/31.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage2/32.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage2/33.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage2/34.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage3/41.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage3/42.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage3/43.tres") as LevelData).duplicate(true),
		(load("res://Systems/Enemies/LevelData/Stage3/44.tres") as LevelData).duplicate(true)
	]

func reset_skill_pools() -> void:
	for tag in skill_pools.keys():
		skill_pools[tag].clear()
	
	skill_pools[Defines.PROG_TAG.Smithing] = [load("res://Systems/Skills/Data/FrostShield.tres")] as Array[Skill]
	skill_pools[Defines.PROG_TAG.Warfare] = [load("res://Systems/Skills/Data/Berserk.tres"), load("res://Systems/Skills/Data/Anger.tres")] as Array[Skill]
	skill_pools[Defines.PROG_TAG.Arcane] = [load("res://Systems/Skills/Data/Focus.tres"), load("res://Systems/Skills/Data/ShadowCast.tres")] as Array[Skill]
	skill_pools[Defines.PROG_TAG.Learning] = [load("res://Systems/Skills/Data/Monk.tres")] as Array[Skill]
	skill_pools[Defines.PROG_TAG.Crafting] = [load("res://Systems/Skills/Data/Block.tres")] as Array[Skill]
	skill_pools[Defines.PROG_TAG.Stewardry] = [load("res://Systems/Skills/Data/Sergeant.tres")] as Array[Skill]
	skill_pools[Defines.PROG_TAG.Charisma] = [load("res://Systems/Skills/Data/Charm.tres")] as Array[Skill]
	skill_pools[Defines.PROG_TAG.Wildcraft] = [load("res://Systems/Skills/Data/Ranger.tres"), load("res://Systems/Skills/Data/Rogue.tres")] as Array[Skill]

func reset_progression_data() -> void:
	buildings.clear()
	villagers.clear()
	reserve_villagers.clear()
	
	var base_path = "res://Systems/Progression/Data/InitialState/"
	
	# Load Buildings
	var forge = load(base_path + "Buildings/Forge.tres").duplicate(true) as Building
	var atelier = load(base_path + "Buildings/Atelier.tres").duplicate(true) as Building
	var armoury = load(base_path + "Buildings/Armoury.tres").duplicate(true) as Building
	var outfitter = load(base_path + "Buildings/Outfitter.tres").duplicate(true) as Building
	
	# Load and assign Rooms
	forge.rooms = [
		load(base_path + "Rooms/AnvilArea.tres").duplicate(true),
		load(base_path + "Rooms/SmeltingFurnace.tres").duplicate(true)
	] as Array[Room]
	atelier.rooms = [
		load(base_path + "Rooms/RitualAltar.tres").duplicate(true),
		load(base_path + "Rooms/EnchantingCircle.tres").duplicate(true)
	] as Array[Room]
	armoury.rooms = [
		load(base_path + "Rooms/AssemblyBench.tres").duplicate(true),
		load(base_path + "Rooms/PlatingStation.tres").duplicate(true)
	] as Array[Room]
	outfitter.rooms = [
		load(base_path + "Rooms/LeatherTannery.tres").duplicate(true),
		load(base_path + "Rooms/SewingLoom.tres").duplicate(true)
	] as Array[Room]
	
	buildings.append_array([forge, atelier, armoury, outfitter])
	
	# Load Villagers
	var v_names = ["Blacksmith", "Soldier", "Mage", "Scholar", "Artisan", "Steward", "Innkeeper", "Ranger"]
	for v in v_names:
		var vil = load(base_path + "Villagers/" + v + ".tres").duplicate(true)
		reserve_villagers.append(vil)
